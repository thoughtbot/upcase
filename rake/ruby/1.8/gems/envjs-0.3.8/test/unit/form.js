module("form");

test("__param__ without a boundary should do query string style uri encoding", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'letmein' }]);
  ok((serialized_params == 'username=jresig&password=letmein'), 'params should be key=value and joined by &');
});

test("__param__ without a boundary should escape spaces in values as + not %20", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'let me in' }]);
  ok((serialized_params == 'username=jresig&password=let+me+in'), 'params should have spaces escaped as + not %20');
});

test("__param__ with a boundary should start with a -- then the boundary and a \\r\\n newline", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'letmein' }], '--aboundary');
  ok(serialized_params.match(/^----aboundary\r\n/), 'params should start with a -- then the boundary and \\r\\n');
});

test("__param__ with a boundary should end with the boundary then -- and a \\r\\n newline", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'letmein' }], '--aboundary');
  ok(serialized_params.match(/--aboundary--\r\n$/), 'params should end with the boundary then -- and \\r\\n');
});

test("__param__ with a boundary should render each key and value with a header, two \\r\\n newlines and the value", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'letmein' }], '--aboundary');
  ok(serialized_params.match(/Content-Disposition: form-data; name="username"\r\n\r\njresig\r\n/), 'username not properly encoded');
  ok(serialized_params.match(/Content-Disposition: form-data; name="password"\r\n\r\nletmein\r\n/), 'password not properly encoded');
});

test("__param__ with a boundary should separate each key-value with --, the boundary and a \\r\\n newline", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'letmein' }], '--aboundary');
  ok(serialized_params.match(/jresig\r\n----aboundary\r\nContent-Disposition: form-data; name="password"/), 'username and password not properly separated');
});

test("__param__ with a boundary should not render spaces in data as + or %20", function() {
  serialized_params = $master.static.__param__([{ name: 'username', value: 'jresig' }, { name: 'password', value: 'let me in' }], '--aboundary');
  ok(!serialized_params.match(/let+me+in/), 'spaces incorrectly encoded as +');
  ok(!serialized_params.match(/let%20me%20in/), 'spaces incorrectly encoded as %20');
  ok(serialized_params.match(/let me in/), 'spaces not left as spaces');
});

