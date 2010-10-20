function _ASSERT(cond, message) {
    if (!cond)
        throw new Error("Assertion failed: " + message);
}
const js_arguments_str = "arguments";
const js_new_str = "new";
const js_typeof_str = "typeof";
const js_void_str = "void";
const js_null_str = "null";
const js_this_str = "this";
const js_false_str = "false";
const js_true_str = "true";
const js_throw_str = "throw";
const js_in_str = "in";
const js_instanceof_str = "instanceof";
const js_getter_str = "getter";
const js_setter_str = "setter";
const NULL = null;
const opinfo = [
{jsop: "JSOP_NOP", opcode: 0, opname: "nop", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_PUSH", opcode: 1, opname: "push", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_POPV", opcode: 2, opname: "popv", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 2, flags: "JOF_BYTE"},
{jsop: "JSOP_ENTERWITH", opcode: 3, opname: "enterwith", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 0, flags: "JOF_BYTE|JOF_PARENHEAD"},
{jsop: "JSOP_LEAVEWITH", opcode: 4, opname: "leavewith", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_RETURN", opcode: 5, opname: "return", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 2, flags: "JOF_BYTE"},
{jsop: "JSOP_GOTO", opcode: 6, opname: "goto", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_JUMP"},
{jsop: "JSOP_IFEQ", opcode: 7, opname: "ifeq", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 4, flags: "JOF_JUMP|JOF_DETECTING"},
{jsop: "JSOP_IFNE", opcode: 8, opname: "ifne", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 0, flags: "JOF_JUMP|JOF_PARENHEAD"},
{jsop: "JSOP_ARGUMENTS", opcode: 9, opname: js_arguments_str, opsrc: js_arguments_str, oplen: 1, pops: 0, pushes: 1, precedence: 18, flags: "JOF_BYTE"},
{jsop: "JSOP_FORARG", opcode: 10, opname: "forarg", opsrc: NULL, oplen: 3, pops: 2, pushes: 2, precedence: 19, flags: "JOF_QARG|JOF_NAME|JOF_FOR"},
{jsop: "JSOP_FORLOCAL", opcode: 11, opname: "forlocal", opsrc: NULL, oplen: 3, pops: 2, pushes: 2, precedence: 19, flags: "JOF_LOCAL|JOF_NAME|JOF_FOR"},
{jsop: "JSOP_DUP", opcode: 12, opname: "dup", opsrc: NULL, oplen: 1, pops: 1, pushes: 2, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_DUP2", opcode: 13, opname: "dup2", opsrc: NULL, oplen: 1, pops: 2, pushes: 4, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_SETCONST", opcode: 14, opname: "setconst", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 3, flags: "JOF_ATOM|JOF_NAME|JOF_SET"},
{jsop: "JSOP_BITOR", opcode: 15, opname: "bitor", opsrc: "|", oplen: 1, pops: 2, pushes: 1, precedence: 7, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_BITXOR", opcode: 16, opname: "bitxor", opsrc: "^", oplen: 1, pops: 2, pushes: 1, precedence: 8, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_BITAND", opcode: 17, opname: "bitand", opsrc: "&", oplen: 1, pops: 2, pushes: 1, precedence: 9, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_EQ", opcode: 18, opname: "eq", opsrc: "==", oplen: 1, pops: 2, pushes: 1, precedence: 10, flags: "JOF_BYTE|JOF_LEFTASSOC|JOF_DETECTING"},
{jsop: "JSOP_NE", opcode: 19, opname: "ne", opsrc: "!=", oplen: 1, pops: 2, pushes: 1, precedence: 10, flags: "JOF_BYTE|JOF_LEFTASSOC|JOF_DETECTING"},
{jsop: "JSOP_LT", opcode: 20, opname: "lt", opsrc: "<", oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_LE", opcode: 21, opname: "le", opsrc: "<=", oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_GT", opcode: 22, opname: "gt", opsrc: ">", oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_GE", opcode: 23, opname: "ge", opsrc: ">=", oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_LSH", opcode: 24, opname: "lsh", opsrc: "<<", oplen: 1, pops: 2, pushes: 1, precedence: 12, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_RSH", opcode: 25, opname: "rsh", opsrc: ">>", oplen: 1, pops: 2, pushes: 1, precedence: 12, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_URSH", opcode: 26, opname: "ursh", opsrc: ">>>", oplen: 1, pops: 2, pushes: 1, precedence: 12, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_ADD", opcode: 27, opname: "add", opsrc: "+", oplen: 1, pops: 2, pushes: 1, precedence: 13, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_SUB", opcode: 28, opname: "sub", opsrc: "-", oplen: 1, pops: 2, pushes: 1, precedence: 13, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_MUL", opcode: 29, opname: "mul", opsrc: "*", oplen: 1, pops: 2, pushes: 1, precedence: 14, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_DIV", opcode: 30, opname: "div", opsrc: "/", oplen: 1, pops: 2, pushes: 1, precedence: 14, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_MOD", opcode: 31, opname: "mod", opsrc: "%", oplen: 1, pops: 2, pushes: 1, precedence: 14, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_NOT", opcode: 32, opname: "not", opsrc: "!", oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE|JOF_DETECTING"},
{jsop: "JSOP_BITNOT", opcode: 33, opname: "bitnot", opsrc: "~", oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE"},
{jsop: "JSOP_NEG", opcode: 34, opname: "neg", opsrc: "- ", oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE"},
{jsop: "JSOP_POS", opcode: 35, opname: "pos", opsrc: "+ ", oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE"},
{jsop: "JSOP_DELNAME", opcode: 36, opname: "delname", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_DEL"},
{jsop: "JSOP_DELPROP", opcode: 37, opname: "delprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_PROP|JOF_DEL"},
{jsop: "JSOP_DELELEM", opcode: 38, opname: "delelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE |JOF_ELEM|JOF_DEL"},
{jsop: "JSOP_TYPEOF", opcode: 39, opname: js_typeof_str, opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE|JOF_DETECTING"},
{jsop: "JSOP_VOID", opcode: 40, opname: js_void_str, opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE"},
{jsop: "JSOP_INCNAME", opcode: 41, opname: "incname", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_INC|JOF_TMPSLOT2"},
{jsop: "JSOP_INCPROP", opcode: 42, opname: "incprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_PROP|JOF_INC|JOF_TMPSLOT2"},
{jsop: "JSOP_INCELEM", opcode: 43, opname: "incelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE |JOF_ELEM|JOF_INC|JOF_TMPSLOT2"},
{jsop: "JSOP_DECNAME", opcode: 44, opname: "decname", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_DEC|JOF_TMPSLOT2"},
{jsop: "JSOP_DECPROP", opcode: 45, opname: "decprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_PROP|JOF_DEC|JOF_TMPSLOT2"},
{jsop: "JSOP_DECELEM", opcode: 46, opname: "decelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE |JOF_ELEM|JOF_DEC|JOF_TMPSLOT2"},
{jsop: "JSOP_NAMEINC", opcode: 47, opname: "nameinc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_INC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_PROPINC", opcode: 48, opname: "propinc", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_PROP|JOF_INC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_ELEMINC", opcode: 49, opname: "eleminc", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE |JOF_ELEM|JOF_INC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_NAMEDEC", opcode: 50, opname: "namedec", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_DEC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_PROPDEC", opcode: 51, opname: "propdec", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_PROP|JOF_DEC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_ELEMDEC", opcode: 52, opname: "elemdec", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE |JOF_ELEM|JOF_DEC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_GETPROP", opcode: 53, opname: "getprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 18, flags: "JOF_ATOM|JOF_PROP"},
{jsop: "JSOP_SETPROP", opcode: 54, opname: "setprop", opsrc: NULL, oplen: 3, pops: 2, pushes: 1, precedence: 3, flags: "JOF_ATOM|JOF_PROP|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_GETELEM", opcode: 55, opname: "getelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 18, flags: "JOF_BYTE |JOF_ELEM|JOF_LEFTASSOC"},
{jsop: "JSOP_SETELEM", opcode: 56, opname: "setelem", opsrc: NULL, oplen: 1, pops: 3, pushes: 1, precedence: 3, flags: "JOF_BYTE |JOF_ELEM|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_CALLNAME", opcode: 57, opname: "callname", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_ATOM|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_CALL", opcode: 58, opname: "call", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 18, flags: "JOF_UINT16|JOF_INVOKE"},
{jsop: "JSOP_NAME", opcode: 59, opname: "name", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM|JOF_NAME"},
{jsop: "JSOP_DOUBLE", opcode: 60, opname: "double", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 16, flags: "JOF_ATOM"},
{jsop: "JSOP_STRING", opcode: 61, opname: "string", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM"},
{jsop: "JSOP_ZERO", opcode: 62, opname: "zero", opsrc: "0", oplen: 1, pops: 0, pushes: 1, precedence: 16, flags: "JOF_BYTE"},
{jsop: "JSOP_ONE", opcode: 63, opname: "one", opsrc: "1", oplen: 1, pops: 0, pushes: 1, precedence: 16, flags: "JOF_BYTE"},
{jsop: "JSOP_NULL", opcode: 64, opname: js_null_str, opsrc: js_null_str, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_THIS", opcode: 65, opname: js_this_str, opsrc: js_this_str, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_FALSE", opcode: 66, opname: js_false_str, opsrc: js_false_str, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_TRUE", opcode: 67, opname: js_true_str, opsrc: js_true_str, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_OR", opcode: 68, opname: "or", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 5, flags: "JOF_JUMP|JOF_DETECTING|JOF_LEFTASSOC"},
{jsop: "JSOP_AND", opcode: 69, opname: "and", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 6, flags: "JOF_JUMP|JOF_DETECTING|JOF_LEFTASSOC"},
{jsop: "JSOP_TABLESWITCH", opcode: 70, opname: "tableswitch", opsrc: NULL, oplen: -1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_TABLESWITCH|JOF_DETECTING|JOF_PARENHEAD"},
{jsop: "JSOP_LOOKUPSWITCH", opcode: 71, opname: "lookupswitch", opsrc: NULL, oplen: -1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_LOOKUPSWITCH|JOF_DETECTING|JOF_PARENHEAD"},
{jsop: "JSOP_STRICTEQ", opcode: 72, opname: "stricteq", opsrc: "===", oplen: 1, pops: 2, pushes: 1, precedence: 10, flags: "JOF_BYTE|JOF_DETECTING|JOF_LEFTASSOC"},
{jsop: "JSOP_STRICTNE", opcode: 73, opname: "strictne", opsrc: "!==", oplen: 1, pops: 2, pushes: 1, precedence: 10, flags: "JOF_BYTE|JOF_DETECTING|JOF_LEFTASSOC"},
{jsop: "JSOP_SETCALL", opcode: 74, opname: "setcall", opsrc: NULL, oplen: 3, pops: -1, pushes: 2, precedence: 18, flags: "JOF_UINT16|JOF_SET"},
{jsop: "JSOP_ITER", opcode: 75, opname: "iter", opsrc: NULL, oplen: 2, pops: 1, pushes: 2, precedence: 0, flags: "JOF_UINT8"},
{jsop: "JSOP_NEXTITER", opcode: 76, opname: "nextiter", opsrc: NULL, oplen: 1, pops: 2, pushes: 3, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_ENDITER", opcode: 77, opname: "enditer", opsrc: NULL, oplen: 1, pops: 2, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_APPLY", opcode: 78, opname: "apply", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 18, flags: "JOF_UINT16|JOF_INVOKE"},
{jsop: "JSOP_SWAP", opcode: 79, opname: "swap", opsrc: NULL, oplen: 1, pops: 2, pushes: 2, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_OBJECT", opcode: 80, opname: "object", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_OBJECT"},
{jsop: "JSOP_POP", opcode: 81, opname: "pop", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 2, flags: "JOF_BYTE"},
{jsop: "JSOP_NEW", opcode: 82, opname: js_new_str, opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 17, flags: "JOF_UINT16|JOF_INVOKE"},
{jsop: "JSOP_TRAP", opcode: 83, opname: "trap", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GETARG", opcode: 84, opname: "getarg", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_QARG |JOF_NAME"},
{jsop: "JSOP_SETARG", opcode: 85, opname: "setarg", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 3, flags: "JOF_QARG |JOF_NAME|JOF_SET"},
{jsop: "JSOP_GETLOCAL", opcode: 86, opname: "getlocal", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_LOCAL|JOF_NAME"},
{jsop: "JSOP_SETLOCAL", opcode: 87, opname: "setlocal", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 3, flags: "JOF_LOCAL|JOF_NAME|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_UINT16", opcode: 88, opname: "uint16", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 16, flags: "JOF_UINT16"},
{jsop: "JSOP_NEWINIT", opcode: 89, opname: "newinit", opsrc: NULL, oplen: 2, pops: 0, pushes: 1, precedence: 19, flags: "JOF_INT8"},
{jsop: "JSOP_ENDINIT", opcode: 90, opname: "endinit", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_INITPROP", opcode: 91, opname: "initprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 3, flags: "JOF_ATOM|JOF_PROP|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_INITELEM", opcode: 92, opname: "initelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 0, precedence: 3, flags: "JOF_BYTE |JOF_ELEM|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_DEFSHARP", opcode: 93, opname: "defsharp", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_USESHARP", opcode: 94, opname: "usesharp", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_INCARG", opcode: 95, opname: "incarg", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_QARG |JOF_NAME|JOF_INC"},
{jsop: "JSOP_DECARG", opcode: 96, opname: "decarg", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_QARG |JOF_NAME|JOF_DEC"},
{jsop: "JSOP_ARGINC", opcode: 97, opname: "arginc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_QARG |JOF_NAME|JOF_INC|JOF_POST"},
{jsop: "JSOP_ARGDEC", opcode: 98, opname: "argdec", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_QARG |JOF_NAME|JOF_DEC|JOF_POST"},
{jsop: "JSOP_INCLOCAL", opcode: 99, opname: "inclocal", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_LOCAL|JOF_NAME|JOF_INC"},
{jsop: "JSOP_DECLOCAL", opcode: 100, opname: "declocal", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_LOCAL|JOF_NAME|JOF_DEC"},
{jsop: "JSOP_LOCALINC", opcode: 101, opname: "localinc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_LOCAL|JOF_NAME|JOF_INC|JOF_POST"},
{jsop: "JSOP_LOCALDEC", opcode: 102, opname: "localdec", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_LOCAL|JOF_NAME|JOF_DEC|JOF_POST"},
{jsop: "JSOP_IMACOP", opcode: 103, opname: "imacop", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_FORNAME", opcode: 104, opname: "forname", opsrc: NULL, oplen: 3, pops: 2, pushes: 2, precedence: 19, flags: "JOF_ATOM|JOF_NAME|JOF_FOR"},
{jsop: "JSOP_FORPROP", opcode: 105, opname: "forprop", opsrc: NULL, oplen: 3, pops: 3, pushes: 2, precedence: 18, flags: "JOF_ATOM|JOF_PROP|JOF_FOR"},
{jsop: "JSOP_FORELEM", opcode: 106, opname: "forelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 3, precedence: 18, flags: "JOF_BYTE |JOF_ELEM|JOF_FOR"},
{jsop: "JSOP_POPN", opcode: 107, opname: "popn", opsrc: NULL, oplen: 3, pops: -1, pushes: 0, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_BINDNAME", opcode: 108, opname: "bindname", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 0, flags: "JOF_ATOM|JOF_NAME|JOF_SET"},
{jsop: "JSOP_SETNAME", opcode: 109, opname: "setname", opsrc: NULL, oplen: 3, pops: 2, pushes: 1, precedence: 3, flags: "JOF_ATOM|JOF_NAME|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_THROW", opcode: 110, opname: js_throw_str, opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_IN", opcode: 111, opname: js_in_str, opsrc: js_in_str, oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_INSTANCEOF", opcode: 112, opname: js_instanceof_str, opsrc: js_instanceof_str, oplen: 1, pops: 2, pushes: 1, precedence: 11, flags: "JOF_BYTE|JOF_LEFTASSOC"},
{jsop: "JSOP_DEBUGGER", opcode: 113, opname: "debugger", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GOSUB", opcode: 114, opname: "gosub", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_JUMP"},
{jsop: "JSOP_RETSUB", opcode: 115, opname: "retsub", opsrc: NULL, oplen: 1, pops: 2, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_EXCEPTION", opcode: 116, opname: "exception", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_LINENO", opcode: 117, opname: "lineno", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_CONDSWITCH", opcode: 118, opname: "condswitch", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE|JOF_PARENHEAD"},
{jsop: "JSOP_CASE", opcode: 119, opname: "case", opsrc: NULL, oplen: 3, pops: 2, pushes: 1, precedence: 0, flags: "JOF_JUMP"},
{jsop: "JSOP_DEFAULT", opcode: 120, opname: "default", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 0, flags: "JOF_JUMP"},
{jsop: "JSOP_EVAL", opcode: 121, opname: "eval", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 18, flags: "JOF_UINT16|JOF_INVOKE"},
{jsop: "JSOP_ENUMELEM", opcode: 122, opname: "enumelem", opsrc: NULL, oplen: 1, pops: 3, pushes: 0, precedence: 3, flags: "JOF_BYTE |JOF_SET"},
{jsop: "JSOP_GETTER", opcode: 123, opname: js_getter_str, opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_SETTER", opcode: 124, opname: js_setter_str, opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_DEFFUN", opcode: 125, opname: "deffun", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_OBJECT|JOF_DECLARING"},
{jsop: "JSOP_DEFCONST", opcode: 126, opname: "defconst", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_ATOM|JOF_DECLARING"},
{jsop: "JSOP_DEFVAR", opcode: 127, opname: "defvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_ATOM|JOF_DECLARING"},
{jsop: "JSOP_LAMBDA", opcode: 128, opname: "lambda", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_OBJECT"},
{jsop: "JSOP_CALLEE", opcode: 129, opname: "callee", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_SETLOCALPOP", opcode: 130, opname: "setlocalpop", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 3, flags: "JOF_LOCAL|JOF_NAME|JOF_SET"},
{jsop: "JSOP_PICK", opcode: 131, opname: "pick", opsrc: NULL, oplen: 2, pops: 0, pushes: 0, precedence: 0, flags: "JOF_UINT8"},
{jsop: "JSOP_TRY", opcode: 132, opname: "try", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_FINALLY", opcode: 133, opname: "finally", opsrc: NULL, oplen: 1, pops: 0, pushes: 2, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GETDSLOT", opcode: 134, opname: "getdslot", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_UINT16|JOF_NAME"},
{jsop: "JSOP_CALLDSLOT", opcode: 135, opname: "calldslot", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_UINT16|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_ARGSUB", opcode: 136, opname: "argsub", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 18, flags: "JOF_QARG |JOF_NAME"},
{jsop: "JSOP_ARGCNT", opcode: 137, opname: "argcnt", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 18, flags: "JOF_BYTE"},
{jsop: "JSOP_DEFLOCALFUN", opcode: 138, opname: "deflocalfun", opsrc: NULL, oplen: 5, pops: 0, pushes: 0, precedence: 0, flags: "JOF_SLOTOBJECT|JOF_DECLARING"},
{jsop: "JSOP_GOTOX", opcode: 139, opname: "gotox", opsrc: NULL, oplen: 5, pops: 0, pushes: 0, precedence: 0, flags: "JOF_JUMPX"},
{jsop: "JSOP_IFEQX", opcode: 140, opname: "ifeqx", opsrc: NULL, oplen: 5, pops: 1, pushes: 0, precedence: 4, flags: "JOF_JUMPX|JOF_DETECTING"},
{jsop: "JSOP_IFNEX", opcode: 141, opname: "ifnex", opsrc: NULL, oplen: 5, pops: 1, pushes: 0, precedence: 0, flags: "JOF_JUMPX|JOF_PARENHEAD"},
{jsop: "JSOP_ORX", opcode: 142, opname: "orx", opsrc: NULL, oplen: 5, pops: 1, pushes: 0, precedence: 5, flags: "JOF_JUMPX|JOF_DETECTING"},
{jsop: "JSOP_ANDX", opcode: 143, opname: "andx", opsrc: NULL, oplen: 5, pops: 1, pushes: 0, precedence: 6, flags: "JOF_JUMPX|JOF_DETECTING"},
{jsop: "JSOP_GOSUBX", opcode: 144, opname: "gosubx", opsrc: NULL, oplen: 5, pops: 0, pushes: 0, precedence: 0, flags: "JOF_JUMPX"},
{jsop: "JSOP_CASEX", opcode: 145, opname: "casex", opsrc: NULL, oplen: 5, pops: 2, pushes: 1, precedence: 0, flags: "JOF_JUMPX"},
{jsop: "JSOP_DEFAULTX", opcode: 146, opname: "defaultx", opsrc: NULL, oplen: 5, pops: 1, pushes: 0, precedence: 0, flags: "JOF_JUMPX"},
{jsop: "JSOP_TABLESWITCHX", opcode: 147, opname: "tableswitchx", opsrc: NULL, oplen: -1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_TABLESWITCHX|JOF_DETECTING|JOF_PARENHEAD"},
{jsop: "JSOP_LOOKUPSWITCHX", opcode: 148, opname: "lookupswitchx", opsrc: NULL, oplen: -1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_LOOKUPSWITCHX|JOF_DETECTING|JOF_PARENHEAD"},
{jsop: "JSOP_BACKPATCH", opcode: 149, opname: "backpatch", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_JUMP|JOF_BACKPATCH"},
{jsop: "JSOP_BACKPATCH_POP", opcode: 150, opname: "backpatch_pop", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 0, flags: "JOF_JUMP|JOF_BACKPATCH"},
{jsop: "JSOP_THROWING", opcode: 151, opname: "throwing", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_SETRVAL", opcode: 152, opname: "setrval", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 2, flags: "JOF_BYTE"},
{jsop: "JSOP_RETRVAL", opcode: 153, opname: "retrval", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GETGVAR", opcode: 154, opname: "getgvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM|JOF_NAME"},
{jsop: "JSOP_SETGVAR", opcode: 155, opname: "setgvar", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 3, flags: "JOF_ATOM|JOF_NAME|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_INCGVAR", opcode: 156, opname: "incgvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_INC|JOF_TMPSLOT2"},
{jsop: "JSOP_DECGVAR", opcode: 157, opname: "decgvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_DEC|JOF_TMPSLOT2"},
{jsop: "JSOP_GVARINC", opcode: 158, opname: "gvarinc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_INC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_GVARDEC", opcode: 159, opname: "gvardec", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 15, flags: "JOF_ATOM|JOF_NAME|JOF_DEC|JOF_POST|JOF_TMPSLOT2"},
{jsop: "JSOP_REGEXP", opcode: 160, opname: "regexp", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_REGEXP"},
{jsop: "JSOP_DEFXMLNS", opcode: 161, opname: "defxmlns", opsrc: NULL, oplen: 1, pops: 1, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_ANYNAME", opcode: 162, opname: "anyname", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE|JOF_XMLNAME"},
{jsop: "JSOP_QNAMEPART", opcode: 163, opname: "qnamepart", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM|JOF_XMLNAME"},
{jsop: "JSOP_QNAMECONST", opcode: 164, opname: "qnameconst", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 19, flags: "JOF_ATOM|JOF_XMLNAME"},
{jsop: "JSOP_QNAME", opcode: 165, opname: "qname", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 0, flags: "JOF_BYTE|JOF_XMLNAME"},
{jsop: "JSOP_TOATTRNAME", opcode: 166, opname: "toattrname", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 19, flags: "JOF_BYTE|JOF_XMLNAME"},
{jsop: "JSOP_TOATTRVAL", opcode: 167, opname: "toattrval", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_ADDATTRNAME", opcode: 168, opname: "addattrname", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 13, flags: "JOF_BYTE"},
{jsop: "JSOP_ADDATTRVAL", opcode: 169, opname: "addattrval", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 13, flags: "JOF_BYTE"},
{jsop: "JSOP_BINDXMLNAME", opcode: 170, opname: "bindxmlname", opsrc: NULL, oplen: 1, pops: 1, pushes: 2, precedence: 3, flags: "JOF_BYTE|JOF_SET"},
{jsop: "JSOP_SETXMLNAME", opcode: 171, opname: "setxmlname", opsrc: NULL, oplen: 1, pops: 3, pushes: 1, precedence: 3, flags: "JOF_BYTE|JOF_SET|JOF_DETECTING"},
{jsop: "JSOP_XMLNAME", opcode: 172, opname: "xmlname", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_DESCENDANTS", opcode: 173, opname: "descendants", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 18, flags: "JOF_BYTE"},
{jsop: "JSOP_FILTER", opcode: 174, opname: "filter", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 0, flags: "JOF_JUMP"},
{jsop: "JSOP_ENDFILTER", opcode: 175, opname: "endfilter", opsrc: NULL, oplen: 3, pops: 2, pushes: 1, precedence: 18, flags: "JOF_JUMP"},
{jsop: "JSOP_TOXML", opcode: 176, opname: "toxml", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_TOXMLLIST", opcode: 177, opname: "toxmllist", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_XMLTAGEXPR", opcode: 178, opname: "xmltagexpr", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_XMLELTEXPR", opcode: 179, opname: "xmleltexpr", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_XMLOBJECT", opcode: 180, opname: "xmlobject", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_OBJECT"},
{jsop: "JSOP_XMLCDATA", opcode: 181, opname: "xmlcdata", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM"},
{jsop: "JSOP_XMLCOMMENT", opcode: 182, opname: "xmlcomment", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_ATOM"},
{jsop: "JSOP_XMLPI", opcode: 183, opname: "xmlpi", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 19, flags: "JOF_ATOM"},
{jsop: "JSOP_CALLPROP", opcode: 184, opname: "callprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 2, precedence: 18, flags: "JOF_ATOM|JOF_PROP|JOF_CALLOP"},
{jsop: "JSOP_GETUPVAR", opcode: 185, opname: "getupvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_UINT16|JOF_NAME"},
{jsop: "JSOP_CALLUPVAR", opcode: 186, opname: "callupvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_UINT16|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_DELDESC", opcode: 187, opname: "deldesc", opsrc: NULL, oplen: 1, pops: 2, pushes: 1, precedence: 15, flags: "JOF_BYTE|JOF_ELEM|JOF_DEL"},
{jsop: "JSOP_UINT24", opcode: 188, opname: "uint24", opsrc: NULL, oplen: 4, pops: 0, pushes: 1, precedence: 16, flags: "JOF_UINT24"},
{jsop: "JSOP_INDEXBASE", opcode: 189, opname: "atombase", opsrc: NULL, oplen: 2, pops: 0, pushes: 0, precedence: 0, flags: "JOF_UINT8|JOF_INDEXBASE"},
{jsop: "JSOP_RESETBASE", opcode: 190, opname: "resetbase", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_RESETBASE0", opcode: 191, opname: "resetbase0", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_STARTXML", opcode: 192, opname: "startxml", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_STARTXMLEXPR", opcode: 193, opname: "startxmlexpr", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_CALLELEM", opcode: 194, opname: "callelem", opsrc: NULL, oplen: 1, pops: 2, pushes: 2, precedence: 18, flags: "JOF_BYTE |JOF_ELEM|JOF_LEFTASSOC|JOF_CALLOP"},
{jsop: "JSOP_STOP", opcode: 195, opname: "stop", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GETXPROP", opcode: 196, opname: "getxprop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 18, flags: "JOF_ATOM|JOF_PROP"},
{jsop: "JSOP_CALLXMLNAME", opcode: 197, opname: "callxmlname", opsrc: NULL, oplen: 1, pops: 1, pushes: 2, precedence: 19, flags: "JOF_BYTE|JOF_CALLOP"},
{jsop: "JSOP_TYPEOFEXPR", opcode: 198, opname: "typeofexpr", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 15, flags: "JOF_BYTE|JOF_DETECTING"},
{jsop: "JSOP_ENTERBLOCK", opcode: 199, opname: "enterblock", opsrc: NULL, oplen: 3, pops: 0, pushes: -1, precedence: 0, flags: "JOF_OBJECT"},
{jsop: "JSOP_LEAVEBLOCK", opcode: 200, opname: "leaveblock", opsrc: NULL, oplen: 3, pops: -1, pushes: 0, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_IFPRIMTOP", opcode: 201, opname: "ifprimtop", opsrc: NULL, oplen: 3, pops: 1, pushes: 1, precedence: 0, flags: "JOF_JUMP|JOF_DETECTING"},
{jsop: "JSOP_PRIMTOP", opcode: 202, opname: "primtop", opsrc: NULL, oplen: 2, pops: 1, pushes: 1, precedence: 0, flags: "JOF_INT8"},
{jsop: "JSOP_GENERATOR", opcode: 203, opname: "generator", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_YIELD", opcode: 204, opname: "yield", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 1, flags: "JOF_BYTE"},
{jsop: "JSOP_ARRAYPUSH", opcode: 205, opname: "arraypush", opsrc: NULL, oplen: 3, pops: 1, pushes: 0, precedence: 3, flags: "JOF_LOCAL"},
{jsop: "JSOP_GETFUNNS", opcode: 206, opname: "getfunns", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 19, flags: "JOF_BYTE"},
{jsop: "JSOP_ENUMCONSTELEM", opcode: 207, opname: "enumconstelem", opsrc: NULL, oplen: 1, pops: 3, pushes: 0, precedence: 3, flags: "JOF_BYTE|JOF_SET"},
{jsop: "JSOP_LEAVEBLOCKEXPR", opcode: 208, opname: "leaveblockexpr", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 3, flags: "JOF_UINT16"},
{jsop: "JSOP_GETTHISPROP", opcode: 209, opname: "getthisprop", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 18, flags: "JOF_ATOM|JOF_VARPROP"},
{jsop: "JSOP_GETARGPROP", opcode: 210, opname: "getargprop", opsrc: NULL, oplen: 5, pops: 0, pushes: 1, precedence: 18, flags: "JOF_SLOTATOM|JOF_VARPROP"},
{jsop: "JSOP_GETLOCALPROP", opcode: 211, opname: "getlocalprop", opsrc: NULL, oplen: 5, pops: 0, pushes: 1, precedence: 18, flags: "JOF_SLOTATOM|JOF_VARPROP"},
{jsop: "JSOP_INDEXBASE1", opcode: 212, opname: "atombase1", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE |JOF_INDEXBASE"},
{jsop: "JSOP_INDEXBASE2", opcode: 213, opname: "atombase2", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE |JOF_INDEXBASE"},
{jsop: "JSOP_INDEXBASE3", opcode: 214, opname: "atombase3", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE |JOF_INDEXBASE"},
{jsop: "JSOP_CALLGVAR", opcode: 215, opname: "callgvar", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_ATOM|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_CALLLOCAL", opcode: 216, opname: "calllocal", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_LOCAL|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_CALLARG", opcode: 217, opname: "callarg", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_QARG |JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_CALLBUILTIN", opcode: 218, opname: "callbuiltin", opsrc: NULL, oplen: 3, pops: 1, pushes: 2, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_INT8", opcode: 219, opname: "int8", opsrc: NULL, oplen: 2, pops: 0, pushes: 1, precedence: 16, flags: "JOF_INT8"},
{jsop: "JSOP_INT32", opcode: 220, opname: "int32", opsrc: NULL, oplen: 5, pops: 0, pushes: 1, precedence: 16, flags: "JOF_INT32"},
{jsop: "JSOP_LENGTH", opcode: 221, opname: "length", opsrc: NULL, oplen: 1, pops: 1, pushes: 1, precedence: 18, flags: "JOF_BYTE|JOF_PROP"},
{jsop: "JSOP_NEWARRAY", opcode: 222, opname: "newarray", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 19, flags: "JOF_UINT16"},
{jsop: "JSOP_HOLE", opcode: 223, opname: "hole", opsrc: NULL, oplen: 1, pops: 0, pushes: 1, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_DEFFUN_FC", opcode: 224, opname: "deffun_fc", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_OBJECT|JOF_DECLARING"},
{jsop: "JSOP_DEFLOCALFUN_FC", opcode: 225, opname: "deflocalfun_fc", opsrc: NULL, oplen: 5, pops: 0, pushes: 0, precedence: 0, flags: "JOF_SLOTOBJECT|JOF_DECLARING"},
{jsop: "JSOP_LAMBDA_FC", opcode: 226, opname: "lambda_fc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_OBJECT"},
{jsop: "JSOP_OBJTOP", opcode: 227, opname: "objtop", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_UINT16"},
{jsop: "JSOP_TRACE", opcode: 228, opname: "trace", opsrc: NULL, oplen: 1, pops: 0, pushes: 0, precedence: 0, flags: "JOF_BYTE"},
{jsop: "JSOP_GETUPVAR_DBG", opcode: 229, opname: "getupvar_dbg", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_UINT16|JOF_NAME"},
{jsop: "JSOP_CALLUPVAR_DBG", opcode: 230, opname: "callupvar_dbg", opsrc: NULL, oplen: 3, pops: 0, pushes: 2, precedence: 19, flags: "JOF_UINT16|JOF_NAME|JOF_CALLOP"},
{jsop: "JSOP_DEFFUN_DBGFC", opcode: 231, opname: "deffun_dbgfc", opsrc: NULL, oplen: 3, pops: 0, pushes: 0, precedence: 0, flags: "JOF_OBJECT|JOF_DECLARING"},
{jsop: "JSOP_DEFLOCALFUN_DBGFC", opcode: 232, opname: "deflocalfun_dbgfc", opsrc: NULL, oplen: 5, pops: 0, pushes: 0, precedence: 0, flags: "JOF_SLOTOBJECT|JOF_DECLARING"},
{jsop: "JSOP_LAMBDA_DBGFC", opcode: 233, opname: "lambda_dbgfc", opsrc: NULL, oplen: 3, pops: 0, pushes: 1, precedence: 19, flags: "JOF_OBJECT"},
{jsop: "JSOP_CONCATN", opcode: 234, opname: "concatn", opsrc: NULL, oplen: 3, pops: -1, pushes: 1, precedence: 13, flags: "JOF_UINT16|JOF_TMPSLOT2"},
];
const opname2info = {};
const jsop2opcode = {};
for (let i = 0; i < opinfo.length; i++) {
    let info = opinfo[i];
    _ASSERT(info.opcode == i, "info.opcode == i");
    opname2info[info.opname] = info;
    jsop2opcode[info.jsop] = info.opcode;
}
function format_offset(n, w) {
    let s = n.toString();
    while (s.length < w)
        s = ' ' + s;
    return s;
}
function immediate(op) {
    let info = op.info;
    let imm1Expr = /^\(/.test(op.imm1);
    if (info.flags.indexOf("JOF_ATOM") >= 0) {
        if (/^(?:void|object|function|string|number|boolean)$/.test(op.imm1))
            return "0, COMMON_TYPE_ATOM_INDEX(JSTYPE_" + op.imm1.toUpperCase() + ")";
        return "0, COMMON_ATOM_INDEX(" + op.imm1 + ")";
    }
    if (info.flags.indexOf("JOF_JUMP") >= 0) {
        _ASSERT(!imm1Expr, "!imm1Expr");
        return ((op.target >> 8) & 0xff) + ", " + (op.target & 0xff);
    }
    if (info.flags.indexOf("JOF_UINT8") >= 0 ||
        info.flags.indexOf("JOF_INT8") >= 0) {
        if (imm1Expr)
            return op.imm1;
        if (isNaN(Number(op.imm1)) || Number(op.imm1) != parseInt(op.imm1))
            throw new Error("invalid 8-bit operand: " + op.imm1);
        return (op.imm1 & 0xff);
    }
    if (info.flags.indexOf("JOF_UINT16") >= 0) {
        if (imm1Expr)
            return '(_ & 0xff00) >> 8, (_ & 0xff)'.replace(/_/g, op.imm1);
        return ((op.imm1 & 0xff00) >> 8) + ", " + (op.imm1 & 0xff);
    }
    throw new Error(info.jsop + " format not yet implemented");
}
function simulate_cfg(imacro, depth, i) {
    while (i < imacro.code.length) {
        let op = imacro.code[i];
        depth -= (op.info.pops < 0) ? 2 + Number(op.imm1) : op.info.pops;
        depth += op.info.pushes;
        if (imacro.depths.hasOwnProperty(i) && imacro.depths[i] != depth)
            throw Error("Mismatched depth at " + imacro.filename + ":" + op.line);
        if (depth > imacro.maxdepth)
            imacro.maxdepth = depth;
        imacro.depths[i] = depth;
        if (op.hasOwnProperty("target_index")) {
            if (op.target_index <= i)
                throw Error("Backward jump at " + imacro.filename + ":" + op.line);
            simulate_cfg(imacro, depth, op.target_index);
            if (op.info.opname == "goto" || op.info.opname == "gotox")
                return;
        }
        ++i;
    }
}
const line_regexp_parts = [
    "^(?:(\\w+):)?",
    "\\s*(\\.?\\w+)",
    "(?:\\s+(\\w+|\\([^)]*\\)))?",
    "(?:\\s+([\\w-]+|\\([^)]*\\)))?",
    "(?:\\s*(?:#.*))?$"
];
const line_regexp = new RegExp(line_regexp_parts.join(""));
function assemble(filename) {
    let igroup = null, imacro = null;
    let opcode2extra = [];
    let igroups = [];
    print("/* GENERATED BY imacro_asm.js -- DO NOT EDIT!!! */");
    let s = snarf(filename);
    let a = s.split('\n');
    for (let i = 0; i < a.length; i++) {
        if (/^\s*(?:#.*)?$/.test(a[i]))
            continue;
        let m = line_regexp.exec(a[i]);
        if (!m)
            throw new Error(a[i]);
        let [, label, opname, imm1, imm2] = m;
        if (opname[0] == '.') {
            if (label)
                throw new Error("invalid label " + label + " before " + opname);
            switch (opname) {
              case ".igroup":
                if (!imm1)
                    throw new Error("missing .igroup name");
                if (igroup)
                    throw new Error("nested .igroup " + imm1);
                let oprange = imm2.match(/^(\w+)(?:-(\w+))?$/);
                if (!oprange)
                    throw new Error("invalid igroup operator range " + imm2);
                let firstop = jsop2opcode[oprange[1]];
                igroup = {
                    name: imm1,
                    firstop: firstop,
                    lastop: oprange[2] ? jsop2opcode[oprange[2]] : firstop,
                    imacros: []
                };
                break;
              case ".imacro":
                if (!igroup)
                    throw new Error(".imacro outside of .igroup");
                if (!imm1)
                    throw new Error("missing .imacro name");
                if (imacro)
                    throw new Error("nested .imacro " + imm1);
                imacro = {
                    name: imm1,
                    offset: 0,
                    code: [],
                    labeldefs: {},
                    labeldef_indexes: {},
                    labelrefs: {},
                    filename: filename,
                    depths: {}
                };
                break;
              case ".end":
                if (!imacro) {
                    if (!igroup)
                        throw new Error(".end without prior .igroup or .imacro");
                    if (imm1 && (imm1 != igroup.name || imm2))
                        throw new Error(".igroup/.end name mismatch");
                    let maxdepth = 0;
                    print("static struct {");
                    for (let j = 0; j < igroup.imacros.length; j++) {
                        imacro = igroup.imacros[j];
                        print("    jsbytecode " + imacro.name + "[" + imacro.offset + "];");
                    }
                    print("} " + igroup.name + "_imacros = {");
                    for (let j = 0; j < igroup.imacros.length; j++) {
                        let depth = 0;
                        imacro = igroup.imacros[j];
                        print("    {");
                        for (let k = 0; k < imacro.code.length; k++) {
                            let op = imacro.code[k];
                            print("/*" + format_offset(op.offset,2) + "*/  " + op.info.jsop +
                                  (op.imm1 ? ", " + immediate(op) : "") + ",");
                        }
                        imacro.maxdepth = 0;
                        simulate_cfg(imacro, 0, 0);
                        if (imacro.maxdepth > maxdepth)
                            maxdepth = imacro.maxdepth;
                        print("    },");
                    }
                    print("};");
                    let opcode = igroup.firstop;
                    let oplast = igroup.lastop;
                    do {
                        opcode2extra[opcode] = maxdepth;
                    } while (opcode++ != oplast);
                    igroups.push(igroup);
                    igroup = null;
                } else {
                    _ASSERT(igroup, "igroup");
                    if (imm1 && imm1 != imacro.name)
                        throw new Error(".imacro/.end name mismatch");
                    for (label in imacro.labelrefs) {
                        if (!imacro.labelrefs.hasOwnProperty(label))
                            continue;
                        if (!imacro.labeldefs.hasOwnProperty(label))
                            throw new Error("label " + label + " used but not defined");
                        let link = imacro.labelrefs[label];
                        _ASSERT(link >= 0, "link >= 0");
                        for (;;) {
                            let op = imacro.code[link];
                            _ASSERT(op, "op");
                            _ASSERT(op.hasOwnProperty('target'), "op.hasOwnProperty('target')");
                            let next = op.target;
                            op.target = imacro.labeldefs[label] - op.offset;
                            op.target_index = imacro.labeldef_indexes[label];
                            if (next < 0)
                                break;
                            link = next;
                        }
                    }
                    igroup.imacros.push(imacro);
                }
                imacro = null;
                break;
              default:
                throw new Error("unknown pseudo-op " + opname);
            }
            continue;
        }
        if (!opname2info.hasOwnProperty(opname))
            throw new Error("unknown opcode " + opname + (label ? " (label " + label + ")" : ""));
        let info = opname2info[opname];
        if (info.oplen == -1)
            throw new Error("unimplemented opcode " + opname);
        if (!imacro)
            throw new Error("opcode " + opname + " outside of .imacro");
        switch (info.opname) {
          case "double":
          case "lookupswitch":
          case "lookupswitchx":
            throw new Error(op.opname + " opcode not yet supported");
        }
        if (label) {
            imacro.labeldefs[label] = imacro.offset;
            imacro.labeldef_indexes[label] = imacro.code.length;
        }
        let op = {offset: imacro.offset, info: info, imm1: imm1, imm2: imm2, line:(i+1) };
        if (info.flags.indexOf("JOF_JUMP") >= 0) {
            if (imacro.labeldefs.hasOwnProperty(imm1)) {
                op.target = imacro.labeldefs[imm1] - op.offset;
                op.target_index = imacro.labeldef_indexes[imm1];
            } else {
                op.target = imacro.labelrefs.hasOwnProperty(imm1) ? imacro.labelrefs[imm1] : -1;
                imacro.labelrefs[imm1] = imacro.code.length;
            }
        }
        imacro.code.push(op);
        imacro.offset += info.oplen;
    }
    print("uint8 js_opcode2extra[JSOP_LIMIT] = {");
    for (let i = 0; i < opinfo.length; i++) {
        print("    " + ((i in opcode2extra) ? opcode2extra[i] : "0") +
              ",  /* " + opinfo[i].jsop + " */");
    }
    print("};");
    print("#define JSOP_IS_IMACOP(x) (0 \\");
    for (let i in opcode2extra)
        print(" || x == " + opinfo[i].jsop + " \\");
    print(")");
    print("jsbytecode*\njs_GetImacroStart(jsbytecode* pc) {");
    for each (let g in igroups) {
        for each (let m in g.imacros) {
            let start = g.name + "_imacros." + m.name;
            print("    if (size_t(pc - " + start + ") < " + m.offset + ") return " + start + ";");
        }
    }
    print("    return NULL;");
    print("}");
}
for (let i = 0; i < arguments.length; i++) {
    try {
        assemble(arguments[i]);
    } catch (e) {
        print(e.name + ": " + e.message + "\n" + e.stack);
    }
}
