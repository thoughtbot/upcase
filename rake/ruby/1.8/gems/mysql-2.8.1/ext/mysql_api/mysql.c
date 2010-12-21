/*	ruby mysql module
 *	$Id: mysql.c 244 2009-02-01 08:43:39Z tommy $
 */

#include <ruby.h>
#ifndef RSTRING_PTR
#define RSTRING_PTR(str) RSTRING(str)->ptr
#endif
#ifndef RSTRING_LEN
#define RSTRING_LEN(str) RSTRING(str)->len
#endif
#ifndef RARRAY_PTR
#define RARRAY_PTR(ary) RARRAY(ary)->ptr
#endif
#ifndef HAVE_RB_STR_SET_LEN
#define rb_str_set_len(str, length) (RSTRING_LEN(str) = (length))
#endif

#ifdef HAVE_MYSQL_H
#include <mysql.h>
#include <errmsg.h>
#include <mysqld_error.h>
#else
#include <mysql/mysql.h>
#include <mysql/errmsg.h>
#include <mysql/mysqld_error.h>
#endif

#define MYSQL_RUBY_VERSION 20801

#define GC_STORE_RESULT_LIMIT 20

#if MYSQL_VERSION_ID < 32224
#define	mysql_field_count	mysql_num_fields
#endif

#define NILorSTRING(obj)	(NIL_P(obj)? NULL: StringValuePtr(obj))
#define NILorINT(obj)		(NIL_P(obj)? 0: NUM2INT(obj))

#define GetMysqlStruct(obj)	(Check_Type(obj, T_DATA), (struct mysql*)DATA_PTR(obj))
#define GetHandler(obj)		(Check_Type(obj, T_DATA), &(((struct mysql*)DATA_PTR(obj))->handler))
#define GetMysqlRes(obj)	(Check_Type(obj, T_DATA), ((struct mysql_res*)DATA_PTR(obj))->res)
#define GetMysqlStmt(obj)	(Check_Type(obj, T_DATA), ((struct mysql_stmt*)DATA_PTR(obj))->stmt)

VALUE cMysql;
VALUE cMysqlRes;
VALUE cMysqlField;
VALUE cMysqlStmt;
VALUE cMysqlRowOffset;
VALUE cMysqlTime;
VALUE eMysql;

static int store_result_count = 0;

struct mysql {
    MYSQL handler;
    char connection;
    char query_with_result;
};

struct mysql_res {
    MYSQL_RES* res;
    char freed;
};

#if MYSQL_VERSION_ID >= 40101
struct mysql_stmt {
    MYSQL_STMT *stmt;
    char closed;
    struct {
	int n;
	MYSQL_BIND *bind;
	unsigned long *length;
	MYSQL_TIME *buffer;
    } param;
    struct {
	int n;
	MYSQL_BIND *bind;
	my_bool *is_null;
	unsigned long *length;
    } result;
    MYSQL_RES *res;
};
#endif

/*	free Mysql class object		*/
static void free_mysql(struct mysql* my)
{
    if (my->connection == Qtrue)
	mysql_close(&my->handler);
    xfree(my);
}

static void free_mysqlres(struct mysql_res* resp)
{
    if (resp->freed == Qfalse) {
	mysql_free_result(resp->res);
	store_result_count--;
    }
    xfree(resp);
}

#if MYSQL_VERSION_ID >= 40101
static void free_mysqlstmt_memory(struct mysql_stmt *s)
{
    if (s->param.bind) {
	xfree(s->param.bind);
	s->param.bind = NULL;
    }
    if (s->param.length) {
	xfree(s->param.length);
	s->param.length = NULL;
    }
    if (s->param.buffer) {
	xfree(s->param.buffer);
	s->param.buffer = NULL;
    }
    s->param.n = 0;
    if (s->res) {
	mysql_free_result(s->res);
	s->res = NULL;
    }
    if (s->result.bind) {
	int i;
	for (i = 0; i < s->result.n; i++) {
	    if (s->result.bind[i].buffer)
		xfree(s->result.bind[i].buffer);
            s->result.bind[i].buffer = NULL;
	}
	xfree(s->result.bind);
	s->result.bind = NULL;
    }
    if (s->result.is_null) {
	xfree(s->result.is_null);
	s->result.is_null = NULL;
    }
    if (s->result.length) {
	xfree(s->result.length);
	s->result.length = NULL;
    }
    s->result.n = 0;
}

static void free_execute_memory(struct mysql_stmt *s)
{
    if (s->res && s->result.bind) {
	int i;
	for (i = 0; i < s->result.n; i++) {
	    if (s->result.bind[i].buffer)
		xfree(s->result.bind[i].buffer);
            s->result.bind[i].buffer = NULL;
	}
    }
    mysql_stmt_free_result(s->stmt);
}

static void free_mysqlstmt(struct mysql_stmt* s)
{
    free_mysqlstmt_memory(s);
    if (s->closed == Qfalse)
	mysql_stmt_close(s->stmt);
    if (s->res)
	mysql_free_result(s->res);
    xfree(s);
}
#endif

static void mysql_raise(MYSQL* m)
{
    VALUE e = rb_exc_new2(eMysql, mysql_error(m));
    rb_iv_set(e, "errno", INT2FIX(mysql_errno(m)));
#if MYSQL_VERSION_ID >= 40101
    rb_iv_set(e, "sqlstate", rb_tainted_str_new2(mysql_sqlstate(m)));
#endif
    rb_exc_raise(e);
}

static VALUE mysqlres2obj(MYSQL_RES* res)
{
    VALUE obj;
    struct mysql_res* resp;
    obj = Data_Make_Struct(cMysqlRes, struct mysql_res, 0, free_mysqlres, resp);
    rb_iv_set(obj, "colname", Qnil);
    rb_iv_set(obj, "tblcolname", Qnil);
    resp->res = res;
    resp->freed = Qfalse;
    rb_obj_call_init(obj, 0, NULL);
    if (++store_result_count > GC_STORE_RESULT_LIMIT)
	rb_gc();
    return obj;
}

/*	make Mysql::Field object	*/
static VALUE make_field_obj(MYSQL_FIELD* f)
{
    VALUE obj;
    if (f == NULL)
	return Qnil;
    obj = rb_obj_alloc(cMysqlField);
    rb_iv_set(obj, "name", f->name? rb_str_freeze(rb_tainted_str_new2(f->name)): Qnil);
    rb_iv_set(obj, "table", f->table? rb_str_freeze(rb_tainted_str_new2(f->table)): Qnil);
    rb_iv_set(obj, "def", f->def? rb_str_freeze(rb_tainted_str_new2(f->def)): Qnil);
    rb_iv_set(obj, "type", INT2NUM(f->type));
    rb_iv_set(obj, "length", INT2NUM(f->length));
    rb_iv_set(obj, "max_length", INT2NUM(f->max_length));
    rb_iv_set(obj, "flags", INT2NUM(f->flags));
    rb_iv_set(obj, "decimals", INT2NUM(f->decimals));
    return obj;
}

/*-------------------------------
 * Mysql class method
 */

/*	init()	*/
static VALUE init(VALUE klass)
{
    struct mysql* myp;
    VALUE obj;

    obj = Data_Make_Struct(klass, struct mysql, 0, free_mysql, myp);
    mysql_init(&myp->handler);
    myp->connection = Qfalse;
    myp->query_with_result = Qtrue;
    rb_obj_call_init(obj, 0, NULL);
    return obj;
}

/*	real_connect(host=nil, user=nil, passwd=nil, db=nil, port=nil, sock=nil, flag=nil)	*/
static VALUE real_connect(int argc, VALUE* argv, VALUE klass)
{
    VALUE host, user, passwd, db, port, sock, flag;
    char *h, *u, *p, *d, *s;
    unsigned int pp, f;
    struct mysql* myp;
    VALUE obj;

#if MYSQL_VERSION_ID >= 32200
    rb_scan_args(argc, argv, "07", &host, &user, &passwd, &db, &port, &sock, &flag);
    d = NILorSTRING(db);
    f = NILorINT(flag);
#elif MYSQL_VERSION_ID >= 32115
    rb_scan_args(argc, argv, "06", &host, &user, &passwd, &port, &sock, &flag);
    f = NILorINT(flag);
#else
    rb_scan_args(argc, argv, "05", &host, &user, &passwd, &port, &sock);
#endif
    h = NILorSTRING(host);
    u = NILorSTRING(user);
    p = NILorSTRING(passwd);
    pp = NILorINT(port);
    s = NILorSTRING(sock);

#ifdef HAVE_RB_THREAD_START_TIMER
    rb_thread_stop_timer();
#endif
    obj = Data_Make_Struct(klass, struct mysql, 0, free_mysql, myp);
#if MYSQL_VERSION_ID >= 32200
    mysql_init(&myp->handler);
    if (mysql_real_connect(&myp->handler, h, u, p, d, pp, s, f) == NULL)
#elif MYSQL_VERSION_ID >= 32115
    if (mysql_real_connect(&myp->handler, h, u, p, pp, s, f) == NULL)
#else
    if (mysql_real_connect(&myp->handler, h, u, p, pp, s) == NULL)
#endif
    {
#ifdef HAVE_RB_THREAD_START_TIMER
        rb_thread_start_timer();
#endif
        mysql_raise(&myp->handler);
    }
#ifdef HAVE_RB_THREAD_START_TIMER
    rb_thread_start_timer();
#endif

    myp->handler.reconnect = 0;
    myp->connection = Qtrue;
    myp->query_with_result = Qtrue;
    rb_obj_call_init(obj, argc, argv);

    return obj;
}

/*	escape_string(string)	*/
static VALUE escape_string(VALUE klass, VALUE str)
{
    VALUE ret;
    Check_Type(str, T_STRING);
    ret = rb_str_new(0, (RSTRING_LEN(str))*2+1);
    rb_str_set_len(ret, mysql_escape_string(RSTRING_PTR(ret), RSTRING_PTR(str), RSTRING_LEN(str)));
    return ret;
}

/*	client_info()	*/
static VALUE client_info(VALUE klass)
{
    return rb_tainted_str_new2(mysql_get_client_info());
}

#if MYSQL_VERSION_ID >= 32332
/*	my_debug(string)	*/
static VALUE my_debug(VALUE obj, VALUE str)
{
    mysql_debug(StringValuePtr(str));
    return obj;
}
#endif

#if MYSQL_VERSION_ID >= 40000
/*	client_version()	*/
static VALUE client_version(VALUE obj)
{
    return INT2NUM(mysql_get_client_version());
}
#endif

/*-------------------------------
 * Mysql object method
 */

#if MYSQL_VERSION_ID >= 32200
/*	real_connect(host=nil, user=nil, passwd=nil, db=nil, port=nil, sock=nil, flag=nil)	*/
static VALUE real_connect2(int argc, VALUE* argv, VALUE obj)
{
    VALUE host, user, passwd, db, port, sock, flag;
    char *h, *u, *p, *d, *s;
    unsigned int pp, f;
    MYSQL* m = GetHandler(obj);
    rb_scan_args(argc, argv, "07", &host, &user, &passwd, &db, &port, &sock, &flag);
    d = NILorSTRING(db);
    f = NILorINT(flag);
    h = NILorSTRING(host);
    u = NILorSTRING(user);
    p = NILorSTRING(passwd);
    pp = NILorINT(port);
    s = NILorSTRING(sock);

#ifdef HAVE_RB_THREAD_START_TIMER
    rb_thread_stop_timer();
#endif
    if (mysql_real_connect(m, h, u, p, d, pp, s, f) == NULL) {
#ifdef HAVE_RB_THREAD_START_TIMER
        rb_thread_start_timer();
#endif
        mysql_raise(m);
    }
#ifdef HAVE_RB_THREAD_START_TIMER
    rb_thread_start_timer();
#endif
    m->reconnect = 0;
    GetMysqlStruct(obj)->connection = Qtrue;

    return obj;
}

/*	options(opt, value=nil)	*/
static VALUE options(int argc, VALUE* argv, VALUE obj)
{
    VALUE opt, val;
    int n;
    my_bool b;
    char* v;
    MYSQL* m = GetHandler(obj);

    rb_scan_args(argc, argv, "11", &opt, &val);
    switch(NUM2INT(opt)) {
    case MYSQL_OPT_CONNECT_TIMEOUT:
#if MYSQL_VERSION_ID >= 40100
    case MYSQL_OPT_PROTOCOL:
#endif
#if MYSQL_VERSION_ID >= 40101
    case MYSQL_OPT_READ_TIMEOUT:
    case MYSQL_OPT_WRITE_TIMEOUT:
#endif
	if (val == Qnil)
	    rb_raise(rb_eArgError, "wrong # of arguments(1 for 2)");
	n = NUM2INT(val);
	v = (char*)&n;
	break;
    case MYSQL_INIT_COMMAND:
    case MYSQL_READ_DEFAULT_FILE:
    case MYSQL_READ_DEFAULT_GROUP:
#if MYSQL_VERSION_ID >= 32349
    case MYSQL_SET_CHARSET_DIR:
    case MYSQL_SET_CHARSET_NAME:
#endif
#if MYSQL_VERSION_ID >= 40100
    case MYSQL_SHARED_MEMORY_BASE_NAME:
#endif
#if MYSQL_VERSION_ID >= 40101
    case MYSQL_SET_CLIENT_IP:
#endif
	if (val == Qnil)
	    rb_raise(rb_eArgError, "wrong # of arguments(1 for 2)");
	v = StringValuePtr(val);
	break;
#if MYSQL_VERSION_ID >= 40101
    case MYSQL_SECURE_AUTH:
	if (val == Qnil || val == Qfalse)
	    b = 1;
	else
	    b = 0;
	v = (char*)&b;
	break;
#endif
#if MYSQL_VERSION_ID >= 32349
    case MYSQL_OPT_LOCAL_INFILE:
	if (val == Qnil || val == Qfalse)
	    v = NULL;
	else {
	    n = 1;
	    v = (char*)&n;
	}
	break;
#endif
    default:
	v = NULL;
    }

    if (mysql_options(m, NUM2INT(opt), v) != 0)
	rb_raise(eMysql, "unknown option: %d", NUM2INT(opt));
    return obj;
}
#endif

#if MYSQL_VERSION_ID >= 32332
/*	real_escape_string(string)	*/
static VALUE real_escape_string(VALUE obj, VALUE str)
{
    MYSQL* m = GetHandler(obj);
    VALUE ret;
    Check_Type(str, T_STRING);
    ret = rb_str_new(0, (RSTRING_LEN(str))*2+1);
    rb_str_set_len(ret, mysql_real_escape_string(m, RSTRING_PTR(ret), RSTRING_PTR(str), RSTRING_LEN(str)));
    return ret;
}
#endif

/*	initialize()	*/
static VALUE initialize(int argc, VALUE* argv, VALUE obj)
{
    return obj;
}

/*	affected_rows()	*/
static VALUE affected_rows(VALUE obj)
{
    return INT2NUM(mysql_affected_rows(GetHandler(obj)));
}

#if MYSQL_VERSION_ID >= 32303
/*	change_user(user=nil, passwd=nil, db=nil)	*/
static VALUE change_user(int argc, VALUE* argv, VALUE obj)
{
    VALUE user, passwd, db;
    char *u, *p, *d;
    MYSQL* m = GetHandler(obj);
    rb_scan_args(argc, argv, "03", &user, &passwd, &db);
    u = NILorSTRING(user);
    p = NILorSTRING(passwd);
    d = NILorSTRING(db);
    if (mysql_change_user(m, u, p, d) != 0)
	mysql_raise(m);
    return obj;
}
#endif

#if MYSQL_VERSION_ID >= 32321
/*	character_set_name()	*/
static VALUE character_set_name(VALUE obj)
{
    return rb_tainted_str_new2(mysql_character_set_name(GetHandler(obj)));
}
#endif

/*	close()		*/
static VALUE my_close(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    mysql_close(m);
    GetMysqlStruct(obj)->connection = Qfalse;
    return obj;
}

#if MYSQL_VERSION_ID < 40000
/*	create_db(db)	*/
static VALUE create_db(VALUE obj, VALUE db)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_create_db(m, StringValuePtr(db)) != 0)
	mysql_raise(m);
    return obj;
}

/*	drop_db(db)	*/
static VALUE drop_db(VALUE obj, VALUE db)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_drop_db(m, StringValuePtr(db)) != 0)
	mysql_raise(m);
    return obj;
}
#endif

#if MYSQL_VERSION_ID >= 32332
/*	dump_debug_info()	*/
static VALUE dump_debug_info(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_dump_debug_info(m) != 0)
	mysql_raise(m);
    return obj;
}
#endif

/*	errno()		*/
static VALUE my_errno(VALUE obj)
{
    return INT2NUM(mysql_errno(GetHandler(obj)));
}

/*	error()		*/
static VALUE my_error(VALUE obj)
{
    return rb_str_new2(mysql_error(GetHandler(obj)));
}

/*	field_count()	*/
static VALUE field_count(VALUE obj)
{
    return INT2NUM(mysql_field_count(GetHandler(obj)));
}

/*	host_info()	*/
static VALUE host_info(VALUE obj)
{
    return rb_tainted_str_new2(mysql_get_host_info(GetHandler(obj)));
}

/*	proto_info()	*/
static VALUE proto_info(VALUE obj)
{
    return INT2NUM(mysql_get_proto_info(GetHandler(obj)));
}

/*	server_info()	*/
static VALUE server_info(VALUE obj)
{
    return rb_tainted_str_new2(mysql_get_server_info(GetHandler(obj)));
}

/*	info()		*/
static VALUE info(VALUE obj)
{
    const char* p = mysql_info(GetHandler(obj));
    return p? rb_tainted_str_new2(p): Qnil;
}

/*	insert_id()	*/
static VALUE insert_id(VALUE obj)
{
    return INT2NUM(mysql_insert_id(GetHandler(obj)));
}

/*	kill(pid)	*/
static VALUE my_kill(VALUE obj, VALUE pid)
{
    int p = NUM2INT(pid);
    MYSQL* m = GetHandler(obj);
    if (mysql_kill(m, p) != 0)
	mysql_raise(m);
    return obj;
}

/*	list_dbs(db=nil)	*/
static VALUE list_dbs(int argc, VALUE* argv, VALUE obj)
{
    unsigned int i, n;
    VALUE db, ret;
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res;

    rb_scan_args(argc, argv, "01", &db);
    res = mysql_list_dbs(m, NILorSTRING(db));
    if (res == NULL)
	mysql_raise(m);

    n = mysql_num_rows(res);
    ret = rb_ary_new2(n);
    for (i=0; i<n; i++)
	rb_ary_store(ret, i, rb_tainted_str_new2(mysql_fetch_row(res)[0]));
    mysql_free_result(res);
    return ret;
}

/*	list_fields(table, field=nil)	*/
static VALUE list_fields(int argc, VALUE* argv, VALUE obj)
{
    VALUE table, field;
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res;
    rb_scan_args(argc, argv, "11", &table, &field);
    res = mysql_list_fields(m, StringValuePtr(table), NILorSTRING(field));
    if (res == NULL)
	mysql_raise(m);
    return mysqlres2obj(res);
}

/*	list_processes()	*/
static VALUE list_processes(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res = mysql_list_processes(m);
    if (res == NULL)
	mysql_raise(m);
    return mysqlres2obj(res);
}

/*	list_tables(table=nil)	*/
static VALUE list_tables(int argc, VALUE* argv, VALUE obj)
{
    VALUE table;
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res;
    unsigned int i, n;
    VALUE ret;

    rb_scan_args(argc, argv, "01", &table);
    res = mysql_list_tables(m, NILorSTRING(table));
    if (res == NULL)
	mysql_raise(m);

    n = mysql_num_rows(res);
    ret = rb_ary_new2(n);
    for (i=0; i<n; i++)
	rb_ary_store(ret, i, rb_tainted_str_new2(mysql_fetch_row(res)[0]));
    mysql_free_result(res);
    return ret;
}

/*	ping()		*/
static VALUE ping(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_ping(m) != 0)
	mysql_raise(m);
    return obj;
}

/*	refresh(r)	*/
static VALUE refresh(VALUE obj, VALUE r)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_refresh(m, NUM2INT(r)) != 0)
	mysql_raise(m);
    return obj;
}

/*	reload()	*/
static VALUE reload(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_reload(m) != 0)
	mysql_raise(m);
    return obj;
}

/*	select_db(db)	*/
static VALUE select_db(VALUE obj, VALUE db)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_select_db(m, StringValuePtr(db)) != 0)
	mysql_raise(m);
    return obj;
}

/*	shutdown()	*/
static VALUE my_shutdown(int argc, VALUE* argv, VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    VALUE level;

    rb_scan_args(argc, argv, "01", &level);
#if MYSQL_VERSION_ID >= 40103
    if (mysql_shutdown(m, NIL_P(level) ? SHUTDOWN_DEFAULT : NUM2INT(level)) != 0)
#else
    if (mysql_shutdown(m) != 0)
#endif
	mysql_raise(m);
    return obj;
}

/*	stat()		*/
static VALUE my_stat(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    const char* s = mysql_stat(m);
    if (s == NULL)
	mysql_raise(m);
    return rb_tainted_str_new2(s);
}

/*	store_result()	*/
static VALUE store_result(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res = mysql_store_result(m);
    if (res == NULL)
	mysql_raise(m);
    return mysqlres2obj(res);
}

/*	thread_id()	*/
static VALUE thread_id(VALUE obj)
{
    return INT2NUM(mysql_thread_id(GetHandler(obj)));
}

/*	use_result()	*/
static VALUE use_result(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    MYSQL_RES* res = mysql_use_result(m);
    if (res == NULL)
	mysql_raise(m);
    return mysqlres2obj(res);
}

static VALUE res_free(VALUE);
/*	query(sql)	*/
static VALUE query(VALUE obj, VALUE sql)
{
    int loop = 0;
    MYSQL* m = GetHandler(obj);
    Check_Type(sql, T_STRING);
    if (GetMysqlStruct(obj)->connection == Qfalse) {
        rb_raise(eMysql, "query: not connected");
    }
    if (rb_block_given_p()) {
	if (mysql_real_query(m, RSTRING_PTR(sql), RSTRING_LEN(sql)) != 0)
	    mysql_raise(m);
	do {
	    MYSQL_RES* res = mysql_store_result(m);
	    if (res == NULL) {
		if (mysql_field_count(m) != 0)
		    mysql_raise(m);
	    } else {
		VALUE robj = mysqlres2obj(res);
		rb_ensure(rb_yield, robj, res_free, robj);
	    }
#if MYSQL_VERSION_ID >= 40101
	    if ((loop = mysql_next_result(m)) > 0)
        	mysql_raise(m);
	} while (loop == 0);
#else
	} while (0);
#endif
	return obj;
    }
    if (mysql_real_query(m, RSTRING_PTR(sql), RSTRING_LEN(sql)) != 0)
	mysql_raise(m);
    if (GetMysqlStruct(obj)->query_with_result == Qfalse)
	return obj;
    if (mysql_field_count(m) == 0)
	return Qnil;
    return store_result(obj);
}

#if MYSQL_VERSION_ID >= 40100
/*	server_version()	*/
static VALUE server_version(VALUE obj)
{
    return INT2NUM(mysql_get_server_version(GetHandler(obj)));
}

/*	warning_count()	*/
static VALUE warning_count(VALUE obj)
{
    return INT2NUM(mysql_warning_count(GetHandler(obj)));
}

/*	commit()	*/
static VALUE commit(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_commit(m) != 0)
        mysql_raise(m);
    return obj;
}

/*	rollback()	*/
static VALUE rollback(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    if (mysql_rollback(m) != 0)
        mysql_raise(m);
    return obj;
}

/*	autocommit()	*/
static VALUE autocommit(VALUE obj, VALUE mode)
{
    MYSQL* m = GetHandler(obj);
    int f;
    f = (mode == Qnil || mode == Qfalse || (rb_type(mode) == T_FIXNUM && NUM2INT(mode) == 0)) ? 0 : 1;
    if (mysql_autocommit(m, f) != 0)
        mysql_raise(m);
    return obj;
}
#endif

#ifdef HAVE_MYSQL_SSL_SET
/*	ssl_set(key=nil, cert=nil, ca=nil, capath=nil, cipher=nil)	*/
static VALUE ssl_set(int argc, VALUE* argv, VALUE obj)
{
    VALUE key, cert, ca, capath, cipher;
    char *s_key, *s_cert, *s_ca, *s_capath, *s_cipher;
    MYSQL* m = GetHandler(obj);
    rb_scan_args(argc, argv, "05", &key, &cert, &ca, &capath, &cipher);
    s_key = NILorSTRING(key);
    s_cert = NILorSTRING(cert);
    s_ca = NILorSTRING(ca);
    s_capath = NILorSTRING(capath);
    s_cipher = NILorSTRING(cipher);
    mysql_ssl_set(m, s_key, s_cert, s_ca, s_capath, s_cipher);
    return obj;
}
#endif

#if MYSQL_VERSION_ID >= 40100
/*	more_results()		*/
static VALUE more_results(VALUE obj)
{
    if (mysql_more_results(GetHandler(obj)) == 0)
	return Qfalse;
    else
	return Qtrue;
}

static VALUE next_result(VALUE obj)
{
    MYSQL* m = GetHandler(obj);
    int ret;
    ret = mysql_next_result(m);
    if (ret > 0)
	mysql_raise(m);
    if (ret == 0)
	return Qtrue;
    return Qfalse;
}
#endif

#if MYSQL_VERSION_ID >= 40101
/*	set_server_option(option)	*/
static VALUE set_server_option(VALUE obj, VALUE option)
{
    MYSQL *m = GetHandler(obj);
    if (mysql_set_server_option(m, NUM2INT(option)) != 0)
	mysql_raise(m);
    return obj;
}

/*	sqlstate()	*/
static VALUE sqlstate(VALUE obj)
{
    MYSQL *m = GetHandler(obj);
    return rb_tainted_str_new2(mysql_sqlstate(m));
}
#endif

#if MYSQL_VERSION_ID >= 40102
/*	stmt_init()	*/
static VALUE stmt_init(VALUE obj)
{
    MYSQL *m = GetHandler(obj);
    MYSQL_STMT *s;
    struct mysql_stmt* stmt;
    my_bool true = 1;
    VALUE st_obj;

    if ((s = mysql_stmt_init(m)) == NULL)
	mysql_raise(m);
    if (mysql_stmt_attr_set(s, STMT_ATTR_UPDATE_MAX_LENGTH, &true))
	rb_raise(rb_eArgError, "mysql_stmt_attr_set() failed");
    st_obj = Data_Make_Struct(cMysqlStmt, struct mysql_stmt, 0, free_mysqlstmt, stmt);
    memset(stmt, 0, sizeof(*stmt));
    stmt->stmt = s;
    stmt->closed = Qfalse;
    return st_obj;
}

static VALUE stmt_prepare(VALUE obj, VALUE query);
/*	prepare(query)	*/
static VALUE prepare(VALUE obj, VALUE query)
{
    VALUE st;
    st = stmt_init(obj);
    return stmt_prepare(st, query);
}
#endif

/*	query_with_result()	*/
static VALUE query_with_result(VALUE obj)
{
    return GetMysqlStruct(obj)->query_with_result? Qtrue: Qfalse;
}

/*	query_with_result=(flag)	*/
static VALUE query_with_result_set(VALUE obj, VALUE flag)
{
    if (TYPE(flag) != T_TRUE && TYPE(flag) != T_FALSE)
        rb_raise(rb_eTypeError, "invalid type, required true or false.");
    GetMysqlStruct(obj)->query_with_result = flag;
    return flag;
}

/*	reconnect()	*/
static VALUE reconnect(VALUE obj)
{
    return GetHandler(obj)->reconnect ? Qtrue : Qfalse;
}

/*	reconnect=(flag)	*/
static VALUE reconnect_set(VALUE obj, VALUE flag)
{
    GetHandler(obj)->reconnect = (flag == Qnil || flag == Qfalse) ? 0 : 1;
    return flag;
}

/*-------------------------------
 * Mysql::Result object method
 */

/*	check if already freed	*/
static void check_free(VALUE obj)
{
    struct mysql_res* resp = DATA_PTR(obj);
    if (resp->freed == Qtrue)
        rb_raise(eMysql, "Mysql::Result object is already freed");
}

/*	data_seek(offset)	*/
static VALUE data_seek(VALUE obj, VALUE offset)
{
    check_free(obj);
    mysql_data_seek(GetMysqlRes(obj), NUM2INT(offset));
    return obj;
}

/*	fetch_field()	*/
static VALUE fetch_field(VALUE obj)
{
    check_free(obj);
    return make_field_obj(mysql_fetch_field(GetMysqlRes(obj)));
}

/*	fetch_fields()	*/
static VALUE fetch_fields(VALUE obj)
{
    MYSQL_RES* res;
    MYSQL_FIELD* f;
    unsigned int n;
    VALUE ret;
    unsigned int i;
    check_free(obj);
    res = GetMysqlRes(obj);
    f = mysql_fetch_fields(res);
    n = mysql_num_fields(res);
    ret = rb_ary_new2(n);
    for (i=0; i<n; i++)
	rb_ary_store(ret, i, make_field_obj(&f[i]));
    return ret;
}

/*	fetch_field_direct(nr)	*/
static VALUE fetch_field_direct(VALUE obj, VALUE nr)
{
    MYSQL_RES* res;
    unsigned int max;
    unsigned int n;
    check_free(obj);
    res = GetMysqlRes(obj);
    max = mysql_num_fields(res);
    n = NUM2INT(nr);
    if (n >= max)
        rb_raise(eMysql, "%d: out of range (max: %d)", n, max-1);
#if MYSQL_VERSION_ID >= 32226
    return make_field_obj(mysql_fetch_field_direct(res, n));
#else
    return make_field_obj(&mysql_fetch_field_direct(res, n));
#endif
}

/*	fetch_lengths()		*/
static VALUE fetch_lengths(VALUE obj)
{
    MYSQL_RES* res;
    unsigned int n;
    unsigned long* lengths;
    VALUE ary;
    unsigned int i;
    check_free(obj);
    res = GetMysqlRes(obj);
    n = mysql_num_fields(res);
    lengths = mysql_fetch_lengths(res);
    if (lengths == NULL)
	return Qnil;
    ary = rb_ary_new2(n);
    for (i=0; i<n; i++)
	rb_ary_store(ary, i, INT2NUM(lengths[i]));
    return ary;
}

/*	fetch_row()	*/
static VALUE fetch_row(VALUE obj)
{
    MYSQL_RES* res;
    unsigned int n;
    MYSQL_ROW row;
    unsigned long* lengths;
    VALUE ary;
    unsigned int i;
    check_free(obj);
    res = GetMysqlRes(obj);
    n = mysql_num_fields(res);
    row = mysql_fetch_row(res);
    lengths = mysql_fetch_lengths(res);
    if (row == NULL)
	return Qnil;
    ary = rb_ary_new2(n);
    for (i=0; i<n; i++)
	rb_ary_store(ary, i, row[i]? rb_tainted_str_new(row[i], lengths[i]): Qnil);
    return ary;
}

/*	fetch_hash2 (internal)	*/
static VALUE fetch_hash2(VALUE obj, VALUE with_table)
{
    MYSQL_RES* res = GetMysqlRes(obj);
    unsigned int n = mysql_num_fields(res);
    MYSQL_ROW row = mysql_fetch_row(res);
    unsigned long* lengths = mysql_fetch_lengths(res);
    MYSQL_FIELD* fields = mysql_fetch_fields(res);
    unsigned int i;
    VALUE hash;
    VALUE colname;
    if (row == NULL)
	return Qnil;
    hash = rb_hash_new();

    if (with_table == Qnil || with_table == Qfalse) {
        colname = rb_iv_get(obj, "colname");
        if (colname == Qnil) {
            colname = rb_ary_new2(n);
            for (i=0; i<n; i++) {
                VALUE s = rb_tainted_str_new2(fields[i].name);
                rb_obj_freeze(s);
                rb_ary_store(colname, i, s);
            }
            rb_obj_freeze(colname);
            rb_iv_set(obj, "colname", colname);
        }
    } else {
        colname = rb_iv_get(obj, "tblcolname");
        if (colname == Qnil) {
            colname = rb_ary_new2(n);
            for (i=0; i<n; i++) {
                int len = strlen(fields[i].table)+strlen(fields[i].name)+1;
                VALUE s = rb_tainted_str_new(NULL, len);
                snprintf(RSTRING_PTR(s), len+1, "%s.%s", fields[i].table, fields[i].name);
                rb_obj_freeze(s);
                rb_ary_store(colname, i, s);
            }
            rb_obj_freeze(colname);
            rb_iv_set(obj, "tblcolname", colname);
        }
    }
    for (i=0; i<n; i++) {
        rb_hash_aset(hash, rb_ary_entry(colname, i), row[i]? rb_tainted_str_new(row[i], lengths[i]): Qnil);
    }
    return hash;
}

/*	fetch_hash(with_table=false)	*/
static VALUE fetch_hash(int argc, VALUE* argv, VALUE obj)
{
    VALUE with_table;
    check_free(obj);
    rb_scan_args(argc, argv, "01", &with_table);
    if (with_table == Qnil)
	with_table = Qfalse;
    return fetch_hash2(obj, with_table);
}

/*	field_seek(offset)	*/
static VALUE field_seek(VALUE obj, VALUE offset)
{
    check_free(obj);
    return INT2NUM(mysql_field_seek(GetMysqlRes(obj), NUM2INT(offset)));
}

/*	field_tell()		*/
static VALUE field_tell(VALUE obj)
{
    check_free(obj);
    return INT2NUM(mysql_field_tell(GetMysqlRes(obj)));
}

/*	free()			*/
static VALUE res_free(VALUE obj)
{
    struct mysql_res* resp = DATA_PTR(obj);
    check_free(obj);
    mysql_free_result(resp->res);
    resp->freed = Qtrue;
    store_result_count--;
    return Qnil;
}

/*	num_fields()		*/
static VALUE num_fields(VALUE obj)
{
    check_free(obj);
    return INT2NUM(mysql_num_fields(GetMysqlRes(obj)));
}

/*	num_rows()	*/
static VALUE num_rows(VALUE obj)
{
    check_free(obj);
    return INT2NUM(mysql_num_rows(GetMysqlRes(obj)));
}

/*	row_seek(offset)	*/
static VALUE row_seek(VALUE obj, VALUE offset)
{
    MYSQL_ROW_OFFSET prev_offset;
    if (CLASS_OF(offset) != cMysqlRowOffset)
	rb_raise(rb_eTypeError, "wrong argument type %s (expected Mysql::RowOffset)", rb_obj_classname(offset));
    check_free(obj);
    prev_offset = mysql_row_seek(GetMysqlRes(obj), DATA_PTR(offset));
    return Data_Wrap_Struct(cMysqlRowOffset, 0, NULL, prev_offset);
}

/*	row_tell()	*/
static VALUE row_tell(VALUE obj)
{
    MYSQL_ROW_OFFSET offset;
    check_free(obj);
    offset = mysql_row_tell(GetMysqlRes(obj));
    return Data_Wrap_Struct(cMysqlRowOffset, 0, NULL, offset);
}

/*	each {...}	*/
static VALUE each(VALUE obj)
{
    VALUE row;
    check_free(obj);
    while ((row = fetch_row(obj)) != Qnil)
	rb_yield(row);
    return obj;
}

/*	each_hash(with_table=false) {...}	*/
static VALUE each_hash(int argc, VALUE* argv, VALUE obj)
{
    VALUE with_table;
    VALUE hash;
    check_free(obj);
    rb_scan_args(argc, argv, "01", &with_table);
    if (with_table == Qnil)
	with_table = Qfalse;
    while ((hash = fetch_hash2(obj, with_table)) != Qnil)
	rb_yield(hash);
    return obj;
}

/*-------------------------------
 * Mysql::Field object method
 */

/*	hash	*/
static VALUE field_hash(VALUE obj)
{
    VALUE h = rb_hash_new();
    rb_hash_aset(h, rb_str_new2("name"), rb_iv_get(obj, "name"));
    rb_hash_aset(h, rb_str_new2("table"), rb_iv_get(obj, "table"));
    rb_hash_aset(h, rb_str_new2("def"), rb_iv_get(obj, "def"));
    rb_hash_aset(h, rb_str_new2("type"), rb_iv_get(obj, "type"));
    rb_hash_aset(h, rb_str_new2("length"), rb_iv_get(obj, "length"));
    rb_hash_aset(h, rb_str_new2("max_length"), rb_iv_get(obj, "max_length"));
    rb_hash_aset(h, rb_str_new2("flags"), rb_iv_get(obj, "flags"));
    rb_hash_aset(h, rb_str_new2("decimals"), rb_iv_get(obj, "decimals"));
    return h;
}

/*	inspect	*/
static VALUE field_inspect(VALUE obj)
{
    VALUE n = rb_iv_get(obj, "name");
    VALUE s = rb_str_new(0, RSTRING_LEN(n) + 16);
    sprintf(RSTRING_PTR(s), "#<Mysql::Field:%s>", RSTRING_PTR(n));
    return s;
}

#define DefineMysqlFieldMemberMethod(m)\
static VALUE field_##m(VALUE obj)\
{return rb_iv_get(obj, #m);}

DefineMysqlFieldMemberMethod(name)
DefineMysqlFieldMemberMethod(table)
DefineMysqlFieldMemberMethod(def)
DefineMysqlFieldMemberMethod(type)
DefineMysqlFieldMemberMethod(length)
DefineMysqlFieldMemberMethod(max_length)
DefineMysqlFieldMemberMethod(flags)
DefineMysqlFieldMemberMethod(decimals)

#ifdef IS_NUM
/*	is_num?	*/
static VALUE field_is_num(VALUE obj)
{
    return IS_NUM(NUM2INT(rb_iv_get(obj, "type"))) ? Qtrue : Qfalse;
}
#endif

#ifdef IS_NOT_NULL
/*	is_not_null?	*/
static VALUE field_is_not_null(VALUE obj)
{
    return IS_NOT_NULL(NUM2INT(rb_iv_get(obj, "flags"))) ? Qtrue : Qfalse;
}
#endif

#ifdef IS_PRI_KEY
/*	is_pri_key?	*/
static VALUE field_is_pri_key(VALUE obj)
{
    return IS_PRI_KEY(NUM2INT(rb_iv_get(obj, "flags"))) ? Qtrue : Qfalse;
}
#endif

#if MYSQL_VERSION_ID >= 40102
/*-------------------------------
 * Mysql::Stmt object method
 */

/*	check if stmt is already closed */
static void check_stmt_closed(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    if (s->closed == Qtrue)
	rb_raise(eMysql, "Mysql::Stmt object is already closed");
}

static void mysql_stmt_raise(MYSQL_STMT* s)
{
    VALUE e = rb_exc_new2(eMysql, mysql_stmt_error(s));
    rb_iv_set(e, "errno", INT2FIX(mysql_stmt_errno(s)));
    rb_iv_set(e, "sqlstate", rb_tainted_str_new2(mysql_stmt_sqlstate(s)));
    rb_exc_raise(e);
}

/*	affected_rows()	*/
static VALUE stmt_affected_rows(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    my_ulonglong n;
    check_stmt_closed(obj);
    n = mysql_stmt_affected_rows(s->stmt);
    return INT2NUM(n);
}

#if 0
/*	attr_get(option)	*/
static VALUE stmt_attr_get(VALUE obj, VALUE opt)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    if (NUM2INT(opt) == STMT_ATTR_UPDATE_MAX_LENGTH) {
	my_bool arg;
	mysql_stmt_attr_get(s->stmt, STMT_ATTR_UPDATE_MAX_LENGTH, &arg);
	return arg == 1 ? Qtrue : Qfalse;
    }
    rb_raise(eMysql, "unknown option: %d", NUM2INT(opt));
}

/*	attr_set(option, arg)	*/
static VALUE stmt_attr_set(VALUE obj, VALUE opt, VALUE val)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    if (NUM2INT(opt) == STMT_ATTR_UPDATE_MAX_LENGTH) {
	my_bool arg;
	arg = (val == Qnil || val == Qfalse) ? 0 : 1;
	mysql_stmt_attr_set(s->stmt, STMT_ATTR_UPDATE_MAX_LENGTH, &arg);
	return obj;
    }
    rb_raise(eMysql, "unknown option: %d", NUM2INT(opt));
}
#endif

/*	bind_result(bind,...)	*/
static VALUE stmt_bind_result(int argc, VALUE *argv, VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    int i;
    MYSQL_FIELD *field;

    check_stmt_closed(obj);
    if (argc != s->result.n)
	rb_raise(eMysql, "bind_result: result value count(%d) != number of argument(%d)", s->result.n, argc);
    for (i = 0; i < argc; i++) {
	if (argv[i] == Qnil || argv[i] == rb_cNilClass) {
	    field = mysql_fetch_fields(s->res);
            s->result.bind[i].buffer_type = field[i].type;
	}
	else if (argv[i] == rb_cString)
	    s->result.bind[i].buffer_type = MYSQL_TYPE_STRING;
	else if (argv[i] == rb_cNumeric || argv[i] == rb_cInteger || argv[i] == rb_cFixnum)
	    s->result.bind[i].buffer_type = MYSQL_TYPE_LONGLONG;
	else if (argv[i] == rb_cFloat)
	    s->result.bind[i].buffer_type = MYSQL_TYPE_DOUBLE;
	else if (argv[i] == cMysqlTime)
	    s->result.bind[i].buffer_type = MYSQL_TYPE_DATETIME;
	else
	    rb_raise(rb_eTypeError, "unrecognized class: %s", RSTRING_PTR(rb_inspect(argv[i])));
	if (mysql_stmt_bind_result(s->stmt, s->result.bind))
	    mysql_stmt_raise(s->stmt);
    }
    return obj;
}

/*	close()	*/
static VALUE stmt_close(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    mysql_stmt_close(s->stmt);
    s->closed = Qtrue;
    return Qnil;
}

/*	data_seek(offset)	*/
static VALUE stmt_data_seek(VALUE obj, VALUE offset)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    mysql_stmt_data_seek(s->stmt, NUM2INT(offset));
    return obj;
}

/*	execute(arg,...)	*/
static VALUE stmt_execute(int argc, VALUE *argv, VALUE obj)
{
    struct mysql_stmt *s = DATA_PTR(obj);
    MYSQL_STMT *stmt = s->stmt;
    int i;

    check_stmt_closed(obj);
    free_execute_memory(s);
    if (s->param.n != argc)
	rb_raise(eMysql, "execute: param_count(%d) != number of argument(%d)", s->param.n, argc);
    if (argc > 0) {
        memset(s->param.bind, 0, sizeof(*(s->param.bind))*argc);
        for (i = 0; i < argc; i++) {
            switch (TYPE(argv[i])) {
            case T_NIL:
                s->param.bind[i].buffer_type = MYSQL_TYPE_NULL;
                break;
            case T_FIXNUM:
#if SIZEOF_INT < SIZEOF_LONG
                s->param.bind[i].buffer_type = MYSQL_TYPE_LONGLONG;
                s->param.bind[i].buffer = &(s->param.buffer[i]);
                *(LONG_LONG*)(s->param.bind[i].buffer) = FIX2LONG(argv[i]);
#else
                s->param.bind[i].buffer_type = MYSQL_TYPE_LONG;
                s->param.bind[i].buffer = &(s->param.buffer[i]);
                *(int*)(s->param.bind[i].buffer) = FIX2INT(argv[i]);
#endif
                break;
            case T_BIGNUM:
                s->param.bind[i].buffer_type = MYSQL_TYPE_LONGLONG;
                s->param.bind[i].buffer = &(s->param.buffer[i]);
                *(LONG_LONG*)(s->param.bind[i].buffer) = rb_big2ll(argv[i]);
                break;
            case T_FLOAT:
                s->param.bind[i].buffer_type = MYSQL_TYPE_DOUBLE;
                s->param.bind[i].buffer = &(s->param.buffer[i]);
                *(double*)(s->param.bind[i].buffer) = NUM2DBL(argv[i]);
                break;
            case T_STRING:
                s->param.bind[i].buffer_type = MYSQL_TYPE_STRING;
                s->param.bind[i].buffer = RSTRING_PTR(argv[i]);
                s->param.bind[i].buffer_length = RSTRING_LEN(argv[i]);
                s->param.length[i] = RSTRING_LEN(argv[i]);
                s->param.bind[i].length = &(s->param.length[i]);
                break;
            default:
                if (CLASS_OF(argv[i]) == rb_cTime) {
                    MYSQL_TIME t;
                    VALUE a = rb_funcall(argv[i], rb_intern("to_a"), 0);
                    s->param.bind[i].buffer_type = MYSQL_TYPE_DATETIME;
                    s->param.bind[i].buffer = &(s->param.buffer[i]);
                    memset(&t, 0, sizeof(t));    /* avoid warning */
                    t.second_part = 0;
                    t.neg = 0;
                    t.second = FIX2INT(RARRAY_PTR(a)[0]);
                    t.minute = FIX2INT(RARRAY_PTR(a)[1]);
                    t.hour = FIX2INT(RARRAY_PTR(a)[2]);
                    t.day = FIX2INT(RARRAY_PTR(a)[3]);
                    t.month = FIX2INT(RARRAY_PTR(a)[4]);
                    t.year = FIX2INT(RARRAY_PTR(a)[5]);
                    *(MYSQL_TIME*)&(s->param.buffer[i]) = t;
                } else if (CLASS_OF(argv[i]) == cMysqlTime) {
                    MYSQL_TIME t;
                    s->param.bind[i].buffer_type = MYSQL_TYPE_DATETIME;
                    s->param.bind[i].buffer = &(s->param.buffer[i]);
                    memset(&t, 0, sizeof(t));    /* avoid warning */
                    t.second_part = 0;
                    t.neg = 0;
                    t.second = NUM2INT(rb_iv_get(argv[i], "second"));
                    t.minute = NUM2INT(rb_iv_get(argv[i], "minute"));
                    t.hour = NUM2INT(rb_iv_get(argv[i], "hour"));
                    t.day = NUM2INT(rb_iv_get(argv[i], "day"));
                    t.month = NUM2INT(rb_iv_get(argv[i], "month"));
                    t.year = NUM2INT(rb_iv_get(argv[i], "year"));
                    *(MYSQL_TIME*)&(s->param.buffer[i]) = t;
                } else
                    rb_raise(rb_eTypeError, "unsupported type: %d", TYPE(argv[i]));
            }
        }
        if (mysql_stmt_bind_param(stmt, s->param.bind))
            mysql_stmt_raise(stmt);
    }

    if (mysql_stmt_execute(stmt))
	mysql_stmt_raise(stmt);
    if (s->res) {
	MYSQL_FIELD *field;
	if (mysql_stmt_store_result(stmt))
	    mysql_stmt_raise(stmt);
	field = mysql_fetch_fields(s->res);
	for (i = 0; i < s->result.n; i++) {
            switch(s->result.bind[i].buffer_type) {
            case MYSQL_TYPE_NULL:
                break;
            case MYSQL_TYPE_TINY:
            case MYSQL_TYPE_SHORT:
            case MYSQL_TYPE_YEAR:
            case MYSQL_TYPE_INT24:
            case MYSQL_TYPE_LONG:
            case MYSQL_TYPE_LONGLONG:
            case MYSQL_TYPE_FLOAT:
            case MYSQL_TYPE_DOUBLE:
                s->result.bind[i].buffer = xmalloc(8);
                s->result.bind[i].buffer_length = 8;
                memset(s->result.bind[i].buffer, 0, 8);
                break;
            case MYSQL_TYPE_DECIMAL:
            case MYSQL_TYPE_STRING:
            case MYSQL_TYPE_VAR_STRING:
            case MYSQL_TYPE_TINY_BLOB:
            case MYSQL_TYPE_BLOB:
            case MYSQL_TYPE_MEDIUM_BLOB:
            case MYSQL_TYPE_LONG_BLOB:
#if MYSQL_VERSION_ID >= 50003
            case MYSQL_TYPE_NEWDECIMAL:
            case MYSQL_TYPE_BIT:
#endif
                s->result.bind[i].buffer = xmalloc(field[i].max_length);
                memset(s->result.bind[i].buffer, 0, field[i].max_length);
                s->result.bind[i].buffer_length = field[i].max_length;
                break;
            case MYSQL_TYPE_TIME:
            case MYSQL_TYPE_DATE:
            case MYSQL_TYPE_DATETIME:
            case MYSQL_TYPE_TIMESTAMP:
                s->result.bind[i].buffer = xmalloc(sizeof(MYSQL_TIME));
                s->result.bind[i].buffer_length = sizeof(MYSQL_TIME);
                memset(s->result.bind[i].buffer, 0, sizeof(MYSQL_TIME));
                break;
            default:
                rb_raise(rb_eTypeError, "unknown buffer_type: %d", s->result.bind[i].buffer_type);
            }
	}
	if (mysql_stmt_bind_result(s->stmt, s->result.bind))
	    mysql_stmt_raise(s->stmt);
    }
    return obj;
}

/*	fetch()		*/
static VALUE stmt_fetch(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    VALUE ret;
    int i;
    int r;

    check_stmt_closed(obj);
    r = mysql_stmt_fetch(s->stmt);
    if (r == MYSQL_NO_DATA)
	return Qnil;
#ifdef MYSQL_DATA_TRUNCATED
    if (r == MYSQL_DATA_TRUNCATED)
        rb_raise(rb_eRuntimeError, "unexpectedly data truncated");
#endif
    if (r == 1)
	mysql_stmt_raise(s->stmt);

    ret = rb_ary_new2(s->result.n);
    for (i = 0; i < s->result.n; i++) {
	if (s->result.is_null[i])
	    rb_ary_push(ret, Qnil);
	else {
	    VALUE v;
	    MYSQL_TIME *t;
	    switch (s->result.bind[i].buffer_type) {
            case MYSQL_TYPE_TINY:
                if (s->result.bind[i].is_unsigned)
                    v = UINT2NUM(*(unsigned char *)s->result.bind[i].buffer);
                else
                    v = INT2NUM(*(signed char *)s->result.bind[i].buffer);
                break;
            case MYSQL_TYPE_SHORT:
            case MYSQL_TYPE_YEAR:
                if (s->result.bind[i].is_unsigned)
                    v = UINT2NUM(*(unsigned short *)s->result.bind[i].buffer);
                else
                    v = INT2NUM(*(short *)s->result.bind[i].buffer);
                break;
            case MYSQL_TYPE_INT24:
            case MYSQL_TYPE_LONG:
                if (s->result.bind[i].is_unsigned)
                    v = UINT2NUM(*(unsigned int *)s->result.bind[i].buffer);
                else
                    v = INT2NUM(*(int *)s->result.bind[i].buffer);
                break;
            case MYSQL_TYPE_LONGLONG:
                if (s->result.bind[i].is_unsigned)
                    v = ULL2NUM(*(unsigned long long *)s->result.bind[i].buffer);
                else
                    v = LL2NUM(*(long long *)s->result.bind[i].buffer);
                break;
            case MYSQL_TYPE_FLOAT:
                v = rb_float_new((double)(*(float *)s->result.bind[i].buffer));
                break;
            case MYSQL_TYPE_DOUBLE:
                v = rb_float_new(*(double *)s->result.bind[i].buffer);
                break;
            case MYSQL_TYPE_TIME:
            case MYSQL_TYPE_DATE:
            case MYSQL_TYPE_DATETIME:
            case MYSQL_TYPE_TIMESTAMP:
                t = (MYSQL_TIME *)s->result.bind[i].buffer;
                v = rb_obj_alloc(cMysqlTime);
                rb_funcall(v, rb_intern("initialize"), 8,
                           INT2FIX(t->year), INT2FIX(t->month),
                           INT2FIX(t->day), INT2FIX(t->hour),
                           INT2FIX(t->minute), INT2FIX(t->second),
                           (t->neg ? Qtrue : Qfalse),
                           INT2FIX(t->second_part));
                break;
            case MYSQL_TYPE_DECIMAL:
            case MYSQL_TYPE_STRING:
            case MYSQL_TYPE_VAR_STRING:
            case MYSQL_TYPE_TINY_BLOB:
            case MYSQL_TYPE_BLOB:
            case MYSQL_TYPE_MEDIUM_BLOB:
            case MYSQL_TYPE_LONG_BLOB:
#if MYSQL_VERSION_ID >= 50003
            case MYSQL_TYPE_NEWDECIMAL:
            case MYSQL_TYPE_BIT:
#endif
                v = rb_tainted_str_new(s->result.bind[i].buffer, s->result.length[i]);
                break;
            default:
                rb_raise(rb_eTypeError, "unknown buffer_type: %d", s->result.bind[i].buffer_type);
	    }
	    rb_ary_push(ret, v);
	}
    }
    return ret;
}

/*	each {...}	*/
static VALUE stmt_each(VALUE obj)
{
    VALUE row;
    check_stmt_closed(obj);
    while ((row = stmt_fetch(obj)) != Qnil)
	rb_yield(row);
    return obj;
}

/*	field_count()	*/
static VALUE stmt_field_count(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    unsigned int n;
    check_stmt_closed(obj);
    n = mysql_stmt_field_count(s->stmt);
    return INT2NUM(n);
}

/*	free_result()	*/
static VALUE stmt_free_result(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    if (mysql_stmt_free_result(s->stmt))
	mysql_stmt_raise(s->stmt);
    return obj;
}

/*	insert_id()	*/
static VALUE stmt_insert_id(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    my_ulonglong n;
    check_stmt_closed(obj);
    n = mysql_stmt_insert_id(s->stmt);
    return INT2NUM(n);
}

/*	num_rows()	*/
static VALUE stmt_num_rows(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    my_ulonglong n;
    check_stmt_closed(obj);
    n = mysql_stmt_num_rows(s->stmt);
    return INT2NUM(n);
}

/*	param_count()		*/
static VALUE stmt_param_count(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    unsigned long n;
    check_stmt_closed(obj);
    n = mysql_stmt_param_count(s->stmt);
    return INT2NUM(n);
}

/*	prepare(query)	*/
static VALUE stmt_prepare(VALUE obj, VALUE query)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    int n;
    int i;
    MYSQL_FIELD *field;

    free_mysqlstmt_memory(s);
    check_stmt_closed(obj);
    Check_Type(query, T_STRING);
    if (mysql_stmt_prepare(s->stmt, RSTRING_PTR(query), RSTRING_LEN(query)))
	mysql_stmt_raise(s->stmt);

    n = mysql_stmt_param_count(s->stmt);
    s->param.n = n;
    s->param.bind = xmalloc(sizeof(s->param.bind[0]) * n);
    s->param.length = xmalloc(sizeof(s->param.length[0]) * n);
    s->param.buffer = xmalloc(sizeof(s->param.buffer[0]) * n);

    s->res = mysql_stmt_result_metadata(s->stmt);
    if (s->res) {
	n = s->result.n = mysql_num_fields(s->res);
	s->result.bind = xmalloc(sizeof(s->result.bind[0]) * n);
	s->result.is_null = xmalloc(sizeof(s->result.is_null[0]) * n);
	s->result.length = xmalloc(sizeof(s->result.length[0]) * n);
	field = mysql_fetch_fields(s->res);
	memset(s->result.bind, 0, sizeof(s->result.bind[0]) * n);
	for (i = 0; i < n; i++) {
            s->result.bind[i].buffer_type = field[i].type;
#if MYSQL_VERSION_ID < 50003
            if (field[i].type == MYSQL_TYPE_DECIMAL)
                s->result.bind[i].buffer_type = MYSQL_TYPE_STRING;
#endif
	    s->result.bind[i].is_null = &(s->result.is_null[i]);
	    s->result.bind[i].length = &(s->result.length[i]);
            s->result.bind[i].is_unsigned = ((field[i].flags & UNSIGNED_FLAG) != 0);
	}
    } else {
	if (mysql_stmt_errno(s->stmt))
	    mysql_stmt_raise(s->stmt);
    }

    return obj;
}

#if 0
/*	reset()		*/
static VALUE stmt_reset(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    check_stmt_closed(obj);
    if (mysql_stmt_reset(s->stmt))
	mysql_stmt_raise(s->stmt);
    return obj;
}
#endif

/*	result_metadata()	*/
static VALUE stmt_result_metadata(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    MYSQL_RES *res;
    check_stmt_closed(obj);
    res = mysql_stmt_result_metadata(s->stmt);
    if (res == NULL) {
      if (mysql_stmt_errno(s->stmt) != 0)
	mysql_stmt_raise(s->stmt);
      return Qnil;
    }
    return mysqlres2obj(res);
}

/*	row_seek(offset)	*/
static VALUE stmt_row_seek(VALUE obj, VALUE offset)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    MYSQL_ROW_OFFSET prev_offset;
    if (CLASS_OF(offset) != cMysqlRowOffset)
	rb_raise(rb_eTypeError, "wrong argument type %s (expected Mysql::RowOffset)", rb_obj_classname(offset));
    check_stmt_closed(obj);
    prev_offset = mysql_stmt_row_seek(s->stmt, DATA_PTR(offset));
    return Data_Wrap_Struct(cMysqlRowOffset, 0, NULL, prev_offset);
}

/*	row_tell()	*/
static VALUE stmt_row_tell(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    MYSQL_ROW_OFFSET offset;
    check_stmt_closed(obj);
    offset = mysql_stmt_row_tell(s->stmt);
    return Data_Wrap_Struct(cMysqlRowOffset, 0, NULL, offset);
}

#if 0
/*	send_long_data(col, data)	*/
static VALUE stmt_send_long_data(VALUE obj, VALUE col, VALUE data)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    int c;
    check_stmt_closed(obj);
    c = NUM2INT(col);
    if (0 <= c && c < s->param.n) {
	s->param.bind[c].buffer_type = MYSQL_TYPE_STRING;
	if (mysql_stmt_bind_param(s->stmt, s->param.bind))
	    mysql_stmt_raise(s->stmt);
    }
    if (mysql_stmt_send_long_data(s->stmt, c, RSTRING_PTR(data), RSTRING_LEN(data)))
	mysql_stmt_raise(s->stmt);
    return obj;
}
#endif

/*	sqlstate()	*/
static VALUE stmt_sqlstate(VALUE obj)
{
    struct mysql_stmt* s = DATA_PTR(obj);
    return rb_tainted_str_new2(mysql_stmt_sqlstate(s->stmt));
}

/*-------------------------------
 * Mysql::Time object method
 */

static VALUE time_initialize(int argc, VALUE* argv, VALUE obj)
{
    VALUE year, month, day, hour, minute, second, neg, second_part;
    rb_scan_args(argc, argv, "08", &year, &month, &day, &hour, &minute, &second, &neg, &second_part);
#define NILorFIXvalue(o)	(NIL_P(o) ? INT2FIX(0) : (Check_Type(o, T_FIXNUM), o))
    rb_iv_set(obj, "year", NILorFIXvalue(year));
    rb_iv_set(obj, "month", NILorFIXvalue(month));
    rb_iv_set(obj, "day", NILorFIXvalue(day));
    rb_iv_set(obj, "hour", NILorFIXvalue(hour));
    rb_iv_set(obj, "minute", NILorFIXvalue(minute));
    rb_iv_set(obj, "second", NILorFIXvalue(second));
    rb_iv_set(obj, "neg", (neg == Qnil || neg == Qfalse) ? Qfalse : Qtrue);
    rb_iv_set(obj, "second_part", NILorFIXvalue(second_part));
    return obj;
}

static VALUE time_inspect(VALUE obj)
{
    char buf[36];
    sprintf(buf, "#<Mysql::Time:%04d-%02d-%02d %02d:%02d:%02d>",
	    NUM2INT(rb_iv_get(obj, "year")),
	    NUM2INT(rb_iv_get(obj, "month")),
	    NUM2INT(rb_iv_get(obj, "day")),
	    NUM2INT(rb_iv_get(obj, "hour")),
	    NUM2INT(rb_iv_get(obj, "minute")),
	    NUM2INT(rb_iv_get(obj, "second")));
    return rb_str_new2(buf);
}

static VALUE time_to_s(VALUE obj)
{
    char buf[20];
    sprintf(buf, "%04d-%02d-%02d %02d:%02d:%02d",
	    NUM2INT(rb_iv_get(obj, "year")),
	    NUM2INT(rb_iv_get(obj, "month")),
	    NUM2INT(rb_iv_get(obj, "day")),
	    NUM2INT(rb_iv_get(obj, "hour")),
	    NUM2INT(rb_iv_get(obj, "minute")),
	    NUM2INT(rb_iv_get(obj, "second")));
    return rb_str_new2(buf);
}

#define DefineMysqlTimeGetMethod(m)\
static VALUE time_get_##m(VALUE obj)\
{return rb_iv_get(obj, #m);}

DefineMysqlTimeGetMethod(year)
DefineMysqlTimeGetMethod(month)
DefineMysqlTimeGetMethod(day)
DefineMysqlTimeGetMethod(hour)
DefineMysqlTimeGetMethod(minute)
DefineMysqlTimeGetMethod(second)
DefineMysqlTimeGetMethod(neg)
DefineMysqlTimeGetMethod(second_part)

#define DefineMysqlTimeSetMethod(m)\
static VALUE time_set_##m(VALUE obj, VALUE v)\
{rb_iv_set(obj, #m, NILorFIXvalue(v)); return v;}

DefineMysqlTimeSetMethod(year)
DefineMysqlTimeSetMethod(month)
DefineMysqlTimeSetMethod(day)
DefineMysqlTimeSetMethod(hour)
DefineMysqlTimeSetMethod(minute)
DefineMysqlTimeSetMethod(second)
DefineMysqlTimeSetMethod(second_part)

static VALUE time_set_neg(VALUE obj, VALUE v)
{
    rb_iv_set(obj, "neg", (v == Qnil || v == Qfalse) ? Qfalse : Qtrue);
    return v;
}

static VALUE time_equal(VALUE obj, VALUE v)
{
    if (CLASS_OF(v) == cMysqlTime &&
	NUM2INT(rb_iv_get(obj, "year")) == NUM2INT(rb_iv_get(v, "year")) &&
	NUM2INT(rb_iv_get(obj, "month")) == NUM2INT(rb_iv_get(v, "month")) &&
	NUM2INT(rb_iv_get(obj, "day")) == NUM2INT(rb_iv_get(v, "day")) &&
	NUM2INT(rb_iv_get(obj, "hour")) == NUM2INT(rb_iv_get(v, "hour")) &&
	NUM2INT(rb_iv_get(obj, "minute")) == NUM2INT(rb_iv_get(v, "minute")) &&
	NUM2INT(rb_iv_get(obj, "second")) == NUM2INT(rb_iv_get(v, "second")) &&
	rb_iv_get(obj, "neg") == rb_iv_get(v, "neg") &&
	NUM2INT(rb_iv_get(obj, "second_part")) == NUM2INT(rb_iv_get(v, "second_part")))
	return Qtrue;
    return Qfalse;
}

#endif

/*-------------------------------
 * Mysql::Error object method
 */

static VALUE error_error(VALUE obj)
{
    return rb_iv_get(obj, "mesg");
}

static VALUE error_errno(VALUE obj)
{
    return rb_iv_get(obj, "errno");
}

static VALUE error_sqlstate(VALUE obj)
{
    return rb_iv_get(obj, "sqlstate");
}

/*-------------------------------
 *	Initialize
 */

void Init_mysql_api(void)
{
    cMysql = rb_define_class("Mysql", rb_cObject);
    cMysqlRes = rb_define_class_under(cMysql, "Result", rb_cObject);
    cMysqlField = rb_define_class_under(cMysql, "Field", rb_cObject);
#if MYSQL_VERSION_ID >= 40102
    cMysqlStmt = rb_define_class_under(cMysql, "Stmt", rb_cObject);
    cMysqlRowOffset = rb_define_class_under(cMysql, "RowOffset", rb_cObject);
    cMysqlTime = rb_define_class_under(cMysql, "Time", rb_cObject);
#endif
    eMysql = rb_define_class_under(cMysql, "Error", rb_eStandardError);

    rb_define_global_const("MysqlRes", cMysqlRes);
    rb_define_global_const("MysqlField", cMysqlField);
    rb_define_global_const("MysqlError", eMysql);

    /* Mysql class method */
    rb_define_singleton_method(cMysql, "init", init, 0);
    rb_define_singleton_method(cMysql, "real_connect", real_connect, -1);
    rb_define_singleton_method(cMysql, "connect", real_connect, -1);
    rb_define_singleton_method(cMysql, "new", real_connect, -1);
    rb_define_singleton_method(cMysql, "escape_string", escape_string, 1);
    rb_define_singleton_method(cMysql, "quote", escape_string, 1);
    rb_define_singleton_method(cMysql, "client_info", client_info, 0);
    rb_define_singleton_method(cMysql, "get_client_info", client_info, 0);
#if MYSQL_VERSION_ID >= 32332
    rb_define_singleton_method(cMysql, "debug", my_debug, 1);
#endif
#if MYSQL_VERSION_ID >= 40000
    rb_define_singleton_method(cMysql, "get_client_version", client_version, 0);
    rb_define_singleton_method(cMysql, "client_version", client_version, 0);
#endif

    /* Mysql object method */
#if MYSQL_VERSION_ID >= 32200
    rb_define_method(cMysql, "real_connect", real_connect2, -1);
    rb_define_method(cMysql, "connect", real_connect2, -1);
    rb_define_method(cMysql, "options", options, -1);
#endif
    rb_define_method(cMysql, "initialize", initialize, -1);
#if MYSQL_VERSION_ID >= 32332
    rb_define_method(cMysql, "escape_string", real_escape_string, 1);
    rb_define_method(cMysql, "quote", real_escape_string, 1);
#else
    rb_define_method(cMysql, "escape_string", escape_string, 1);
    rb_define_method(cMysql, "quote", escape_string, 1);
#endif
    rb_define_method(cMysql, "client_info", client_info, 0);
    rb_define_method(cMysql, "get_client_info", client_info, 0);
    rb_define_method(cMysql, "affected_rows", affected_rows, 0);
#if MYSQL_VERSION_ID >= 32303
    rb_define_method(cMysql, "change_user", change_user, -1);
#endif
#if MYSQL_VERSION_ID >= 32321
    rb_define_method(cMysql, "character_set_name", character_set_name, 0);
#endif
    rb_define_method(cMysql, "close", my_close, 0);
#if MYSQL_VERSION_ID < 40000
    rb_define_method(cMysql, "create_db", create_db, 1);
    rb_define_method(cMysql, "drop_db", drop_db, 1);
#endif
#if MYSQL_VERSION_ID >= 32332
    rb_define_method(cMysql, "dump_debug_info", dump_debug_info, 0);
#endif
    rb_define_method(cMysql, "errno", my_errno, 0);
    rb_define_method(cMysql, "error", my_error, 0);
    rb_define_method(cMysql, "field_count", field_count, 0);
#if MYSQL_VERSION_ID >= 40000
    rb_define_method(cMysql, "get_client_version", client_version, 0);
    rb_define_method(cMysql, "client_version", client_version, 0);
#endif
    rb_define_method(cMysql, "get_host_info", host_info, 0);
    rb_define_method(cMysql, "host_info", host_info, 0);
    rb_define_method(cMysql, "get_proto_info", proto_info, 0);
    rb_define_method(cMysql, "proto_info", proto_info, 0);
    rb_define_method(cMysql, "get_server_info", server_info, 0);
    rb_define_method(cMysql, "server_info", server_info, 0);
    rb_define_method(cMysql, "info", info, 0);
    rb_define_method(cMysql, "insert_id", insert_id, 0);
    rb_define_method(cMysql, "kill", my_kill, 1);
    rb_define_method(cMysql, "list_dbs", list_dbs, -1);
    rb_define_method(cMysql, "list_fields", list_fields, -1);
    rb_define_method(cMysql, "list_processes", list_processes, 0);
    rb_define_method(cMysql, "list_tables", list_tables, -1);
#if MYSQL_VERSION_ID >= 32200
    rb_define_method(cMysql, "ping", ping, 0);
#endif
    rb_define_method(cMysql, "query", query, 1);
    rb_define_method(cMysql, "real_query", query, 1);
    rb_define_method(cMysql, "refresh", refresh, 1);
    rb_define_method(cMysql, "reload", reload, 0);
    rb_define_method(cMysql, "select_db", select_db, 1);
    rb_define_method(cMysql, "shutdown", my_shutdown, -1);
    rb_define_method(cMysql, "stat", my_stat, 0);
    rb_define_method(cMysql, "store_result", store_result, 0);
    rb_define_method(cMysql, "thread_id", thread_id, 0);
    rb_define_method(cMysql, "use_result", use_result, 0);
#if MYSQL_VERSION_ID >= 40100
    rb_define_method(cMysql, "get_server_version", server_version, 0);
    rb_define_method(cMysql, "server_version", server_version, 0);
    rb_define_method(cMysql, "warning_count", warning_count, 0);
    rb_define_method(cMysql, "commit", commit, 0);
    rb_define_method(cMysql, "rollback", rollback, 0);
    rb_define_method(cMysql, "autocommit", autocommit, 1);
#endif
#ifdef HAVE_MYSQL_SSL_SET
    rb_define_method(cMysql, "ssl_set", ssl_set, -1);
#endif
#if MYSQL_VERSION_ID >= 40102
    rb_define_method(cMysql, "stmt_init", stmt_init, 0);
    rb_define_method(cMysql, "prepare", prepare, 1);
#endif
#if MYSQL_VERSION_ID >= 40100
    rb_define_method(cMysql, "more_results", more_results, 0);
    rb_define_method(cMysql, "more_results?", more_results, 0);
    rb_define_method(cMysql, "next_result", next_result, 0);
#endif
#if MYSQL_VERSION_ID >= 40101
    rb_define_method(cMysql, "set_server_option", set_server_option, 1);
    rb_define_method(cMysql, "sqlstate", sqlstate, 0);
#endif
    rb_define_method(cMysql, "query_with_result", query_with_result, 0);
    rb_define_method(cMysql, "query_with_result=", query_with_result_set, 1);

    rb_define_method(cMysql, "reconnect", reconnect, 0);
    rb_define_method(cMysql, "reconnect=", reconnect_set, 1);

    /* Mysql constant */
    rb_define_const(cMysql, "VERSION", INT2FIX(MYSQL_RUBY_VERSION));
#if MYSQL_VERSION_ID >= 32200
    rb_define_const(cMysql, "OPT_CONNECT_TIMEOUT", INT2NUM(MYSQL_OPT_CONNECT_TIMEOUT));
    rb_define_const(cMysql, "OPT_COMPRESS", INT2NUM(MYSQL_OPT_COMPRESS));
    rb_define_const(cMysql, "OPT_NAMED_PIPE", INT2NUM(MYSQL_OPT_NAMED_PIPE));
    rb_define_const(cMysql, "INIT_COMMAND", INT2NUM(MYSQL_INIT_COMMAND));
    rb_define_const(cMysql, "READ_DEFAULT_FILE", INT2NUM(MYSQL_READ_DEFAULT_FILE));
    rb_define_const(cMysql, "READ_DEFAULT_GROUP", INT2NUM(MYSQL_READ_DEFAULT_GROUP));
#endif
#if MYSQL_VERSION_ID >= 32349
    rb_define_const(cMysql, "SET_CHARSET_DIR", INT2NUM(MYSQL_SET_CHARSET_DIR));
    rb_define_const(cMysql, "SET_CHARSET_NAME", INT2NUM(MYSQL_SET_CHARSET_NAME));
    rb_define_const(cMysql, "OPT_LOCAL_INFILE", INT2NUM(MYSQL_OPT_LOCAL_INFILE));
#endif
#if MYSQL_VERSION_ID >= 40100
    rb_define_const(cMysql, "OPT_PROTOCOL", INT2NUM(MYSQL_OPT_PROTOCOL));
    rb_define_const(cMysql, "SHARED_MEMORY_BASE_NAME", INT2NUM(MYSQL_SHARED_MEMORY_BASE_NAME));
#endif
#if MYSQL_VERSION_ID >= 40101
    rb_define_const(cMysql, "OPT_READ_TIMEOUT", INT2NUM(MYSQL_OPT_READ_TIMEOUT));
    rb_define_const(cMysql, "OPT_WRITE_TIMEOUT", INT2NUM(MYSQL_OPT_WRITE_TIMEOUT));
    rb_define_const(cMysql, "SECURE_AUTH", INT2NUM(MYSQL_SECURE_AUTH));
    rb_define_const(cMysql, "OPT_GUESS_CONNECTION", INT2NUM(MYSQL_OPT_GUESS_CONNECTION));
    rb_define_const(cMysql, "OPT_USE_EMBEDDED_CONNECTION", INT2NUM(MYSQL_OPT_USE_EMBEDDED_CONNECTION));
    rb_define_const(cMysql, "OPT_USE_REMOTE_CONNECTION", INT2NUM(MYSQL_OPT_USE_REMOTE_CONNECTION));
    rb_define_const(cMysql, "SET_CLIENT_IP", INT2NUM(MYSQL_SET_CLIENT_IP));
#endif
    rb_define_const(cMysql, "REFRESH_GRANT", INT2NUM(REFRESH_GRANT));
    rb_define_const(cMysql, "REFRESH_LOG", INT2NUM(REFRESH_LOG));
    rb_define_const(cMysql, "REFRESH_TABLES", INT2NUM(REFRESH_TABLES));
#ifdef REFRESH_HOSTS
    rb_define_const(cMysql, "REFRESH_HOSTS", INT2NUM(REFRESH_HOSTS));
#endif
#ifdef REFRESH_STATUS
    rb_define_const(cMysql, "REFRESH_STATUS", INT2NUM(REFRESH_STATUS));
#endif
#ifdef REFRESH_THREADS
    rb_define_const(cMysql, "REFRESH_THREADS", INT2NUM(REFRESH_THREADS));
#endif
#ifdef REFRESH_SLAVE
    rb_define_const(cMysql, "REFRESH_SLAVE", INT2NUM(REFRESH_SLAVE));
#endif
#ifdef REFRESH_MASTER
    rb_define_const(cMysql, "REFRESH_MASTER", INT2NUM(REFRESH_MASTER));
#endif
#ifdef CLIENT_LONG_PASSWORD
#endif
#ifdef CLIENT_FOUND_ROWS
    rb_define_const(cMysql, "CLIENT_FOUND_ROWS", INT2NUM(CLIENT_FOUND_ROWS));
#endif
#ifdef CLIENT_LONG_FLAG
#endif
#ifdef CLIENT_CONNECT_WITH_DB
#endif
#ifdef CLIENT_NO_SCHEMA
    rb_define_const(cMysql, "CLIENT_NO_SCHEMA", INT2NUM(CLIENT_NO_SCHEMA));
#endif
#ifdef CLIENT_COMPRESS
    rb_define_const(cMysql, "CLIENT_COMPRESS", INT2NUM(CLIENT_COMPRESS));
#endif
#ifdef CLIENT_ODBC
    rb_define_const(cMysql, "CLIENT_ODBC", INT2NUM(CLIENT_ODBC));
#endif
#ifdef CLIENT_LOCAL_FILES
    rb_define_const(cMysql, "CLIENT_LOCAL_FILES", INT2NUM(CLIENT_LOCAL_FILES));
#endif
#ifdef CLIENT_IGNORE_SPACE
    rb_define_const(cMysql, "CLIENT_IGNORE_SPACE", INT2NUM(CLIENT_IGNORE_SPACE));
#endif
#ifdef CLIENT_CHANGE_USER
    rb_define_const(cMysql, "CLIENT_CHANGE_USER", INT2NUM(CLIENT_CHANGE_USER));
#endif
#ifdef CLIENT_INTERACTIVE
    rb_define_const(cMysql, "CLIENT_INTERACTIVE", INT2NUM(CLIENT_INTERACTIVE));
#endif
#ifdef CLIENT_SSL
    rb_define_const(cMysql, "CLIENT_SSL", INT2NUM(CLIENT_SSL));
#endif
#ifdef CLIENT_IGNORE_SIGPIPE
    rb_define_const(cMysql, "CLIENT_IGNORE_SIGPIPE", INT2NUM(CLIENT_IGNORE_SIGPIPE));
#endif
#ifdef CLIENT_TRANSACTIONS
    rb_define_const(cMysql, "CLIENT_TRANSACTIONS", INT2NUM(CLIENT_TRANSACTIONS));
#endif
#ifdef CLIENT_MULTI_STATEMENTS
    rb_define_const(cMysql, "CLIENT_MULTI_STATEMENTS", INT2NUM(CLIENT_MULTI_STATEMENTS));
#endif
#ifdef CLIENT_MULTI_RESULTS
    rb_define_const(cMysql, "CLIENT_MULTI_RESULTS", INT2NUM(CLIENT_MULTI_RESULTS));
#endif
#if MYSQL_VERSION_ID >= 40101
    rb_define_const(cMysql, "OPTION_MULTI_STATEMENTS_ON", INT2NUM(MYSQL_OPTION_MULTI_STATEMENTS_ON));
    rb_define_const(cMysql, "OPTION_MULTI_STATEMENTS_OFF", INT2NUM(MYSQL_OPTION_MULTI_STATEMENTS_OFF));
#endif

    /* Mysql::Result object method */
    rb_define_method(cMysqlRes, "data_seek", data_seek, 1);
    rb_define_method(cMysqlRes, "fetch_field", fetch_field, 0);
    rb_define_method(cMysqlRes, "fetch_fields", fetch_fields, 0);
    rb_define_method(cMysqlRes, "fetch_field_direct", fetch_field_direct, 1);
    rb_define_method(cMysqlRes, "fetch_lengths", fetch_lengths, 0);
    rb_define_method(cMysqlRes, "fetch_row", fetch_row, 0);
    rb_define_method(cMysqlRes, "fetch_hash", fetch_hash, -1);
    rb_define_method(cMysqlRes, "field_seek", field_seek, 1);
    rb_define_method(cMysqlRes, "field_tell", field_tell, 0);
    rb_define_method(cMysqlRes, "free", res_free, 0);
    rb_define_method(cMysqlRes, "num_fields", num_fields, 0);
    rb_define_method(cMysqlRes, "num_rows", num_rows, 0);
    rb_define_method(cMysqlRes, "row_seek", row_seek, 1);
    rb_define_method(cMysqlRes, "row_tell", row_tell, 0);
    rb_define_method(cMysqlRes, "each", each, 0);
    rb_define_method(cMysqlRes, "each_hash", each_hash, -1);

    /* MysqlField object method */
    rb_define_method(cMysqlField, "name", field_name, 0);
    rb_define_method(cMysqlField, "table", field_table, 0);
    rb_define_method(cMysqlField, "def", field_def, 0);
    rb_define_method(cMysqlField, "type", field_type, 0);
    rb_define_method(cMysqlField, "length", field_length, 0);
    rb_define_method(cMysqlField, "max_length", field_max_length, 0);
    rb_define_method(cMysqlField, "flags", field_flags, 0);
    rb_define_method(cMysqlField, "decimals", field_decimals, 0);
    rb_define_method(cMysqlField, "hash", field_hash, 0);
    rb_define_method(cMysqlField, "inspect", field_inspect, 0);
#ifdef IS_NUM
    rb_define_method(cMysqlField, "is_num?", field_is_num, 0);
#endif
#ifdef IS_NOT_NULL
    rb_define_method(cMysqlField, "is_not_null?", field_is_not_null, 0);
#endif
#ifdef IS_PRI_KEY
    rb_define_method(cMysqlField, "is_pri_key?", field_is_pri_key, 0);
#endif

    /* Mysql::Field constant: TYPE */
    rb_define_const(cMysqlField, "TYPE_TINY", INT2NUM(FIELD_TYPE_TINY));
#if MYSQL_VERSION_ID >= 32115
    rb_define_const(cMysqlField, "TYPE_ENUM", INT2NUM(FIELD_TYPE_ENUM));
#endif
    rb_define_const(cMysqlField, "TYPE_DECIMAL", INT2NUM(FIELD_TYPE_DECIMAL));
    rb_define_const(cMysqlField, "TYPE_SHORT", INT2NUM(FIELD_TYPE_SHORT));
    rb_define_const(cMysqlField, "TYPE_LONG", INT2NUM(FIELD_TYPE_LONG));
    rb_define_const(cMysqlField, "TYPE_FLOAT", INT2NUM(FIELD_TYPE_FLOAT));
    rb_define_const(cMysqlField, "TYPE_DOUBLE", INT2NUM(FIELD_TYPE_DOUBLE));
    rb_define_const(cMysqlField, "TYPE_NULL", INT2NUM(FIELD_TYPE_NULL));
    rb_define_const(cMysqlField, "TYPE_TIMESTAMP", INT2NUM(FIELD_TYPE_TIMESTAMP));
    rb_define_const(cMysqlField, "TYPE_LONGLONG", INT2NUM(FIELD_TYPE_LONGLONG));
    rb_define_const(cMysqlField, "TYPE_INT24", INT2NUM(FIELD_TYPE_INT24));
    rb_define_const(cMysqlField, "TYPE_DATE", INT2NUM(FIELD_TYPE_DATE));
    rb_define_const(cMysqlField, "TYPE_TIME", INT2NUM(FIELD_TYPE_TIME));
    rb_define_const(cMysqlField, "TYPE_DATETIME", INT2NUM(FIELD_TYPE_DATETIME));
#if MYSQL_VERSION_ID >= 32130
    rb_define_const(cMysqlField, "TYPE_YEAR", INT2NUM(FIELD_TYPE_YEAR));
#endif
#if MYSQL_VERSION_ID >= 50003
    rb_define_const(cMysqlField, "TYPE_BIT", INT2NUM(FIELD_TYPE_BIT));
    rb_define_const(cMysqlField, "TYPE_NEWDECIMAL", INT2NUM(FIELD_TYPE_NEWDECIMAL));
#endif
    rb_define_const(cMysqlField, "TYPE_SET", INT2NUM(FIELD_TYPE_SET));
    rb_define_const(cMysqlField, "TYPE_BLOB", INT2NUM(FIELD_TYPE_BLOB));
    rb_define_const(cMysqlField, "TYPE_STRING", INT2NUM(FIELD_TYPE_STRING));
#if MYSQL_VERSION_ID >= 40000
    rb_define_const(cMysqlField, "TYPE_VAR_STRING", INT2NUM(FIELD_TYPE_VAR_STRING));
#endif
    rb_define_const(cMysqlField, "TYPE_CHAR", INT2NUM(FIELD_TYPE_CHAR));

    /* Mysql::Field constant: FLAG */
    rb_define_const(cMysqlField, "NOT_NULL_FLAG", INT2NUM(NOT_NULL_FLAG));
    rb_define_const(cMysqlField, "PRI_KEY_FLAG", INT2NUM(PRI_KEY_FLAG));
    rb_define_const(cMysqlField, "UNIQUE_KEY_FLAG", INT2NUM(UNIQUE_KEY_FLAG));
    rb_define_const(cMysqlField, "MULTIPLE_KEY_FLAG", INT2NUM(MULTIPLE_KEY_FLAG));
    rb_define_const(cMysqlField, "BLOB_FLAG", INT2NUM(BLOB_FLAG));
    rb_define_const(cMysqlField, "UNSIGNED_FLAG", INT2NUM(UNSIGNED_FLAG));
    rb_define_const(cMysqlField, "ZEROFILL_FLAG", INT2NUM(ZEROFILL_FLAG));
    rb_define_const(cMysqlField, "BINARY_FLAG", INT2NUM(BINARY_FLAG));
#ifdef ENUM_FLAG
    rb_define_const(cMysqlField, "ENUM_FLAG", INT2NUM(ENUM_FLAG));
#endif
#ifdef AUTO_INCREMENT_FLAG
    rb_define_const(cMysqlField, "AUTO_INCREMENT_FLAG", INT2NUM(AUTO_INCREMENT_FLAG));
#endif
#ifdef TIMESTAMP_FLAG
    rb_define_const(cMysqlField, "TIMESTAMP_FLAG", INT2NUM(TIMESTAMP_FLAG));
#endif
#ifdef SET_FLAG
    rb_define_const(cMysqlField, "SET_FLAG", INT2NUM(SET_FLAG));
#endif
#ifdef NUM_FLAG
    rb_define_const(cMysqlField, "NUM_FLAG", INT2NUM(NUM_FLAG));
#endif
#ifdef PART_KEY_FLAG
    rb_define_const(cMysqlField, "PART_KEY_FLAG", INT2NUM(PART_KEY_FLAG));
#endif

#if MYSQL_VERSION_ID >= 40102
    /* Mysql::Stmt object method */
    rb_define_method(cMysqlStmt, "affected_rows", stmt_affected_rows, 0);
#if 0
    rb_define_method(cMysqlStmt, "attr_get", stmt_attr_get, 1);
    rb_define_method(cMysqlStmt, "attr_set", stmt_attr_set, 2);
#endif
    rb_define_method(cMysqlStmt, "bind_result", stmt_bind_result, -1);
    rb_define_method(cMysqlStmt, "close", stmt_close, 0);
    rb_define_method(cMysqlStmt, "data_seek", stmt_data_seek, 1);
    rb_define_method(cMysqlStmt, "each", stmt_each, 0);
    rb_define_method(cMysqlStmt, "execute", stmt_execute, -1);
    rb_define_method(cMysqlStmt, "fetch", stmt_fetch, 0);
    rb_define_method(cMysqlStmt, "field_count", stmt_field_count, 0);
    rb_define_method(cMysqlStmt, "free_result", stmt_free_result, 0);
    rb_define_method(cMysqlStmt, "insert_id", stmt_insert_id, 0);
    rb_define_method(cMysqlStmt, "num_rows", stmt_num_rows, 0);
    rb_define_method(cMysqlStmt, "param_count", stmt_param_count, 0);
    rb_define_method(cMysqlStmt, "prepare", stmt_prepare, 1);
#if 0
    rb_define_method(cMysqlStmt, "reset", stmt_reset, 0);
#endif
    rb_define_method(cMysqlStmt, "result_metadata", stmt_result_metadata, 0);
    rb_define_method(cMysqlStmt, "row_seek", stmt_row_seek, 1);
    rb_define_method(cMysqlStmt, "row_tell", stmt_row_tell, 0);
#if 0
    rb_define_method(cMysqlStmt, "send_long_data", stmt_send_long_data, 2);
#endif
    rb_define_method(cMysqlStmt, "sqlstate", stmt_sqlstate, 0);

#if 0
    rb_define_const(cMysqlStmt, "ATTR_UPDATE_MAX_LENGTH", INT2NUM(STMT_ATTR_UPDATE_MAX_LENGTH));
#endif

    /* Mysql::Time object method */
    rb_define_method(cMysqlTime, "initialize", time_initialize, -1);
    rb_define_method(cMysqlTime, "inspect", time_inspect, 0);
    rb_define_method(cMysqlTime, "to_s", time_to_s, 0);
    rb_define_method(cMysqlTime, "year", time_get_year, 0);
    rb_define_method(cMysqlTime, "month", time_get_month, 0);
    rb_define_method(cMysqlTime, "day", time_get_day, 0);
    rb_define_method(cMysqlTime, "hour", time_get_hour, 0);
    rb_define_method(cMysqlTime, "minute", time_get_minute, 0);
    rb_define_method(cMysqlTime, "second", time_get_second, 0);
    rb_define_method(cMysqlTime, "neg", time_get_neg, 0);
    rb_define_method(cMysqlTime, "second_part", time_get_second_part, 0);
    rb_define_method(cMysqlTime, "year=", time_set_year, 1);
    rb_define_method(cMysqlTime, "month=", time_set_month, 1);
    rb_define_method(cMysqlTime, "day=", time_set_day, 1);
    rb_define_method(cMysqlTime, "hour=", time_set_hour, 1);
    rb_define_method(cMysqlTime, "minute=", time_set_minute, 1);
    rb_define_method(cMysqlTime, "second=", time_set_second, 1);
    rb_define_method(cMysqlTime, "neg=", time_set_neg, 1);
    rb_define_method(cMysqlTime, "second_part=", time_set_second_part, 1);
    rb_define_method(cMysqlTime, "==", time_equal, 1);

#endif

    /* Mysql::Error object method */
    rb_define_method(eMysql, "error", error_error, 0);
    rb_define_method(eMysql, "errno", error_errno, 0);
    rb_define_method(eMysql, "sqlstate", error_sqlstate, 0);

    /* Mysql::Error constant */
#define rb_define_mysql_const(s) rb_define_const(eMysql, #s, INT2NUM(s))
#include "error_const.h"
}
