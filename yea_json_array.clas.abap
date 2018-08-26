class YEA_JSON_ARRAY definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods APPEND
    importing
      !VALUE type ref to YEA_JSON_VALUE .
  methods REMOVE
    importing
      !INDEX type INT4.
  methods GET
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_VALUE .
  methods SIZE
    returning
      value(RETURNING) type INT4 .
  methods STRING
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type STRING .
  methods INTEGER
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type INT4 .
  methods FLOAT
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type F .
  methods BOOLEAN
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ABAP_BOOL .
  methods OBJECT
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_OBJECT .
  methods ARRAY
    importing
      !INDEX type INT4
    returning
      value(RETURNING) type ref to YEA_JSON_ARRAY .
  protected section.
  private section.

    types: __lvalue type standard table of ref to yea_json_value.
    data: _values type __lvalue.

ENDCLASS.



CLASS YEA_JSON_ARRAY IMPLEMENTATION.


  method append.
    append value to _values.
  endmethod.


  method ARRAY.
    try.
      data(idx) = index.
      returning = cast yea_json_array( _values[ idx ] ).
    catch cx_root.
    endtry.
  endmethod.


  method BOOLEAN.
    try.
      data(idx) = index.
      returning = cast yea_json_boolean( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method FLOAT.
    try.
      data(idx) = index.
      returning = cast yea_json_number( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method get.
    try.
        returning = _values[ index ].
      catch cx_root.
    endtry.
  endmethod.


  method INTEGER.
    try.
      data(idx) = index.
      data(cst) = cast yea_json_number( _values[ idx ] ).
      data intval type int4.
      intval = cst->get( ).
      returning = intval.
    catch cx_root.
    endtry.
  endmethod.


  method OBJECT.
    try.
      data(idx) = index.
      returning = cast yea_json_object( _values[ idx ] ).
    catch cx_root.
    endtry.
  endmethod.


  method remove.
    delete _values index index.
  endmethod.


  method size.
    returning = lines( _values ).
  endmethod.


  method STRING.
    try.
      data(idx) = index.
      returning = cast yea_json_string( _values[ idx ] )->get( ).
    catch cx_root.
    endtry.
  endmethod.


  method YEA_JSON_VALUE~EQUAL.

    if ( me->yea_json_value~type( ) = object->type( ) ).
      data(arr_cast) = cast yea_json_array( object ).
      if ( arr_cast->size( ) <> size( ) ).
        return.
      endif.

      do me->size( ) times.
        data(el_me) = me->get( sy-index ).
        data(el_ob) = arr_cast->get( sy-index ).
        if ( el_me->equal( el_ob ) = abap_false ).
          return.
        endif.
      enddo.

      returning = abap_true.

    endif.
  endmethod.


  method yea_json_value~type.
    returning = yea_json_types=>type_array.
  endmethod.
ENDCLASS.
