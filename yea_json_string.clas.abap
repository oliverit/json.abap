class YEA_JSON_STRING definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods CONSTRUCTOR
    importing
      !VALUE type STRING optional .
  methods SET
    importing
      value(VALUE) type STRING .
  methods GET
    returning
      value(RETURNING) type STRING .
protected section.
private section.

  data _VALUE type STRING .
ENDCLASS.



CLASS YEA_JSON_STRING IMPLEMENTATION.


  method CONSTRUCTOR.
    _value = value.
  endmethod.


  method GET.
    returning = me->_value.
  endmethod.


  method SET.
    _value = value.
  endmethod.


  method YEA_JSON_VALUE~EQUAL.
    if ( me->yea_json_value~type( ) = object->type( ) ).
      data(obj_cast) = cast yea_json_string( object ).
      if ( obj_cast->get( ) = me->get( ) ).
        returning = abap_true.
      endif.
    endif.
  endmethod.


  method YEA_JSON_VALUE~TYPE.
    returning = yea_json_types=>type_string.
  endmethod.
ENDCLASS.
