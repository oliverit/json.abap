class YEA_JSON_BOOLEAN definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods CONSTRUCTOR
    importing
      !VALUE type ABAP_BOOL .
  methods GET
    returning
      value(RETURNING) type ABAP_BOOL .
  methods SET
    importing
      !VALUE type ABAP_BOOL .
protected section.
private section.

  data _VALUE type ABAP_BOOL .
ENDCLASS.



CLASS YEA_JSON_BOOLEAN IMPLEMENTATION.


  method CONSTRUCTOR.
    me->_value = value.
  endmethod.


  method GET.
    returning = _value.
  endmethod.


  method SET.
    _value = value.
  endmethod.


  method YEA_JSON_VALUE~EQUAL.
    if ( me->yea_json_value~type( ) = object->type( ) ).
      data(obj_cast) = cast yea_json_boolean( object ).
      if ( obj_cast->get( ) = me->get( ) ).
        returning = abap_true.
      endif.
    endif.
  endmethod.


  method YEA_JSON_VALUE~TYPE.
    returning = yea_json_types=>type_boolean.
  endmethod.
ENDCLASS.
