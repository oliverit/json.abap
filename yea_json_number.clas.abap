class YEA_JSON_NUMBER definition
  public
  final
  create public .

public section.

  interfaces YEA_JSON_VALUE .

  methods CONSTRUCTOR
    importing
      !VALUE type F optional .
  methods GET
    returning
      value(RETURNING) type F .
  methods SET
    importing
      !VALUE type F .
protected section.
private section.

  data _VALUE type F .
ENDCLASS.



CLASS YEA_JSON_NUMBER IMPLEMENTATION.


  method CONSTRUCTOR.
    _value = value.
  endmethod.


  method GET.
    returning = _value.
  endmethod.


  method SET.
    _value = value.
  endmethod.


  method YEA_JSON_VALUE~TYPE.
    returning = yea_json_types=>type_number.
  endmethod.
ENDCLASS.
