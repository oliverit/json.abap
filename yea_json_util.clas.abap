class YEA_JSON_UTIL definition
  public
  final
  create public .

public section.

  class-methods OBJECT_ADD_STRING
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING
      !VALUE type STRING .
  class-methods OBJECT_ADD_NUMBER
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING
      !NUMBER type F .
  class-methods OBJECT_ADD_BOOLEAN
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING
      !BOOLEAN type ABAP_BOOL .
  class-methods OBJECT_ADD_NULL
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING .
  class-methods OBJECT_ADD_ARRAY
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING
      !ARRAY type ref to YEA_JSON_ARRAY .
  class-methods OBJECT_ADD_OBJECT
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
      !NAME type STRING
      !ADD type ref to YEA_JSON_OBJECT .
  class-methods ARRAY_APPEND_STRING
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
      !STRING type STRING .
  class-methods ARRAY_APPEND_NUMBER
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
      !NUMBER type F .
  class-methods ARRAY_APPEND_BOOLEAN
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
      !BOOLEAN type ABAP_BOOL .
  class-methods ARRAY_APPEND_NULL
    importing
      !ARRAY type ref to YEA_JSON_ARRAY .
  class-methods ARRAY_APPEND_ARRAY
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
      !ADD type ref to YEA_JSON_ARRAY .
  class-methods ARRAY_APPEND_OBJECT
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
      !OBJECT type ref to YEA_JSON_OBJECT .
  protected section.
  private section.
ENDCLASS.



CLASS YEA_JSON_UTIL IMPLEMENTATION.


  method array_append_array.
    array->append( add ).
  endmethod.


  method array_append_boolean.
    array->append( new yea_json_boolean( boolean ) ).
  endmethod.


  method array_append_null.
    array->append( new yea_json_null( ) ).
  endmethod.


  method array_append_number.
    array->append( new yea_json_number( number ) ).
  endmethod.


  method array_append_object.
    array->append( object ).
  endmethod.


  method array_append_string.
    array->append( new yea_json_string( string ) ).
  endmethod.


  method object_add_array.
    object->add(
      new yea_json_pair(
        name = name
        value = array ) ).
  endmethod.


  method object_add_boolean.
    data(ref) = new yea_json_boolean( boolean ).
    object->add( new yea_json_pair( name = name value = ref ) ).
  endmethod.


  method object_add_null.
    object->add( new yea_json_pair( name = name value = new yea_json_null( ) ) ).
  endmethod.


  method object_add_number.
    object->add( new yea_json_pair( name = name value = new yea_json_number( number ) ) ).
  endmethod.


  method object_add_object.
    object->add( new yea_json_pair( name = name value = add ) ).
  endmethod.


  method object_add_string.
    object->add( new yea_json_pair( name = name value = new yea_json_string( value ) ) ).
  endmethod.
ENDCLASS.
