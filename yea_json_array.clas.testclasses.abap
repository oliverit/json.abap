*"* use this source file for your ABAP unit test classes

class unit_test definition for testing
  risk level harmless
  duration short.

  public section.
  protected section.
  private section.
    methods: emptyArray for testing.
    methods: emptyAfterRemove for testing.
    methods: notEmptyAfterRemove for testing.
    methods: nullArray for testing.
    methods: numberArray for testing.
    methods: stringArray for testing.
    methods: arrayArray for testing.
    methods: objectArray for testing.
    methods: mixedArray for testing.
endclass.

class unit_test implementation.

  method emptyArray.
    data(json_array) = new yea_json_array( ).
    cl_abap_unit_assert=>assert_equals(
      act = json_array->size( )
      exp = 0
    ).
  endmethod.

  method emptyAfterRemove.
    data(json_array) = new yea_json_array( ).
    json_array->append( new yea_json_null( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json_array->size( )
      exp = 1
    ).
    json_array->remove( 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = json_array->size( )
      exp = 0
    ).
  endmethod.

  method notEmptyAfterRemove.
    data(json_array) = new yea_json_array( ).
    json_array->append( new yea_json_null( ) ).
    json_array->append( new yea_json_null( ) ).
    json_array->remove( 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = json_array->size( )
      exp = 1
    ).
  endmethod.

  method nullArray.
    data(json_array) = new yea_json_array( ).
    json_array->append( new yea_json_null( ) ).
    json_array->append( new yea_json_null( ) ).
    cl_abap_unit_assert=>assert_equals(
      act = json_array->size( )
      exp = 2
    ).
  endmethod.

  method numberArray.
    data(number_array) = new yea_json_array( ).
    number_array->append( new yea_json_number( 1 ) ).
    number_array->append( new yea_json_number( 100 ) ).
    number_array->append( new yea_json_number( 1000 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = number_array->size( )
      exp = 3
    ).
    cl_abap_unit_assert=>assert_equals(
      act = number_array->integer( 1 )
      exp = 1
    ).
    cl_abap_unit_assert=>assert_equals(
      act = number_array->integer( 2 )
      exp = 100
    ).
    cl_abap_unit_assert=>assert_equals(
      act = number_array->integer( 3 )
      exp = 1000
    ).
  endmethod.

  method stringArray.
    data(string_array) = new yea_json_array( ).
    string_array->append( new yea_json_string( 'one' ) ).
    string_array->append( new yea_json_string( 'two' ) ).
    string_array->append( new yea_json_string( 'three' ) ).
    cl_abap_unit_assert=>assert_equals(
      act = string_array->size( )
      exp = 3
    ).
    cl_abap_unit_assert=>assert_equals(
      act = string_array->string( 1 )
      exp = 'one'
    ).
    cl_abap_unit_assert=>assert_equals(
      act = string_array->string( 2 )
      exp = 'two'
    ).
    cl_abap_unit_assert=>assert_equals(
      act = string_array->string( 3 )
      exp = 'three'
    ).
  endmethod.

  method arrayArray.
    data(array_array) = new yea_json_array( ).
    data(arr1) = new yea_json_array( ).
    data(arr2) = new yea_json_array( ).
    data(arr3) = new yea_json_array( ).
    array_array->append( arr1 ).
    array_array->append( arr2 ).
    array_array->append( arr3 ).
    cl_abap_unit_assert=>assert_equals(
      act = array_array->array( 1 )
      exp = arr1
    ).
    cl_abap_unit_assert=>assert_equals(
      act = array_array->array( 2 )
      exp = arr2
    ).
    cl_abap_unit_assert=>assert_equals(
      act = array_array->array( 3 )
      exp = arr3
    ).
  endmethod.

  method objectArray.
    data(object_array) = new yea_json_array( ).
    data(obj1) = new yea_json_object( ).
    data(obj2) = new yea_json_object( ).
    data(obj3) = new yea_json_object( ).
    object_array->append( obj1 ).
    object_array->append( obj2 ).
    object_array->append( obj3 ).
    cl_abap_unit_assert=>assert_equals(
      act = object_array->object( 1 )
      exp = obj1
    ).
    cl_abap_unit_assert=>assert_equals(
      act = object_array->object( 2 )
      exp = obj2
    ).
    cl_abap_unit_assert=>assert_equals(
      act = object_array->object( 3 )
      exp = obj3
    ).
  endmethod.

  method mixedArray.
    data(mixed_array) = new yea_json_array( ).
    data(null) = new yea_json_null( ).
    data(number) = new yea_json_number( 0 ).
    data(string) = new yea_json_string( 'durp' ).
    data(array) = new yea_json_array( ).
    array->append( null ).
    array->append( number ).
    array->append( string ).
    data(object) = new yea_json_object( ).
    object->add( new yea_json_pair( name = 'null' value = null ) ).
    object->add( new yea_json_pair( name = 'number' value = number ) ).
    object->add( new yea_json_pair( name = 'string' value = string ) ).
    array->append( object ).
    cl_abap_unit_assert=>assert_equals(
      act = array->get( 1 )
      exp = null
    ).
    cl_abap_unit_assert=>assert_equals(
      act = array->integer( 2 )
      exp = 0
    ).
    cl_abap_unit_assert=>assert_equals(
      act = array->string( 3 )
      exp = 'durp'
    ).
  endmethod.

endclass.
