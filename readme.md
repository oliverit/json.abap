
# Json.abap

Minimal ABAP framework for serializing and deserializing anonymous JSON objects. 

## Deserialize

### Basic Types

```abap
data json_string type string.
json_string = '{' &&
                 '"string_attr": "string_value",' &&
                 '"number_attr": 1000,' &&
                 '"true_attr": true,' &&
                 '"false_attr": false,' &&
                 '"null_attr": null' &&
              '}'.
data(json_ref)   = cast yea_json_object( yea_json_parser=>deserialize( json_string ) ).
write : / 'String: ', json_ref->get_string( 'string_attr' ).
write : / 'Number: ', json_ref->get_int( 'number_attr' ).
write : / 'True: ',   json_ref->get_boolean( 'true_attr' ).
write : / 'False: ',  json_ref->get_boolean( 'false_attr' ).
```

![Debug Table](http://imgur.com/cB3L65P)

![Output](http://i.imgur.com/NIp3lz6.jpg)

### Objects

```abap
data json_string type string.
json_string = '{"a":{"b":{"c":{"d":{"e":"inner"}}}}}'.
data(json_ref)   = cast yea_json_object( yea_json_parser=>deserialize( json_string ) ).

data(str_out) = json_ref->get_object( 'a'
                       )->get_object( 'b'
                       )->get_object( 'c'
                       )->get_object( 'd'
                       )->get_string( 'e' ).
write : / '"e" value', str_out.
```

### Arrays

```abap
data json_string type string.
json_string = '[ [ ], [ ], [ 0, 1, 2, 3, [5, 6, 7] ], [ ] ]'.
data(json_ref)   = cast yea_json_array( yea_json_parser=>deserialize( json_string ) ).

data(second_array) = json_ref->to_array( 2 ).
data(third_array) = second_array->to_array( 4 ).
data(s_0) = second_array->to_int( 0 ).
data(s_1) = second_array->to_int( 1 ).
data(s_2) = second_array->to_int( 2 ).
data(t_0) = third_array->to_int( 0 ).
data(t_1) = third_array->to_int( 1 ).
data(t_2) = third_array->to_int( 2 ).
write : / 's_0: ', s_0.
write : / 's_1: ', s_1.
write : / 's_2: ', s_2.
write : / 't_0: ', t_0.
write : / 't_1: ', t_1.
write : / 't_2: ', t_2.
```

### Mixed

```abap
data json_string type string.
json_string = '[ {"obj":"a"}, [ ], [ 0, 1, 2, 3, [5, 6, 7] ], [{"obj":"b","kool":"aid"}] ]'.
data(json_ref)   = cast yea_json_array( yea_json_parser=>deserialize( json_string ) ).

data(first_object) = json_ref->to_object( 0 ).
data(last_object) = json_ref->to_array( 3 )->to_object( 0 ).
write : / 'First object value: ', first_object->get_string( 'obj' ).
write : / 'Second object.'.
write : / ' value: ', last_object->get_string( 'obj' ).
write : / ' kool: ', last_object->get_string( 'kool' ).
```

## Serialize

```abap
data(json_obj) = new yea_json_object( ).
yea_json_util=>object_add_null( object = json_obj name = 'key1' ).
yea_json_util=>object_add_boolean( object = json_obj name = 'key2' boolean = abap_false ).
yea_json_util=>object_add_boolean( object = json_obj name = 'key3' boolean = abap_true ).
yea_json_util=>object_add_string( object = json_obj name = 'key4' value = 'testing' ).
yea_json_util=>object_add_number( object = json_obj name = 'key5' number = 100 ).

data(_arr) = new yea_json_array( ).
yea_json_util=>array_append_string( array = _arr string = 'zero' ).
yea_json_util=>array_append_string( array = _arr string = 'one' ).
yea_json_util=>array_append_string( array = _arr string = 'two' ).
yea_json_util=>object_add_array( object = json_obj name = 'key6' array = _arr ).

data(to_string) = yea_json_parser=>serialize( json_obj ).
data(json_ref)   = cast yea_json_object( yea_json_parser=>deserialize( to_string ) ).
write : / 'json text: ', to_string.
if ( json_ref is not bound ).
      write : / 'validation failed'.
endif.
" {"key1":null,"key2":false,"key3":true,"key4":"testing","key5":1.0000000000000000E+02,"key6":["zero","one","two"]}
```

