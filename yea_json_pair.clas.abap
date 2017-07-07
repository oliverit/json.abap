class yea_json_pair definition
  public
  final
  create public .

  public section.

    methods constructor
      importing
        !name  type string
        !value type ref to yea_json_value .
    methods name
      returning
        value(returning) type string .
    methods value
      returning
        value(returning) type ref to yea_json_value .
  protected section.
  private section.

    data _name type string .
    data _value type ref to yea_json_value .
ENDCLASS.



CLASS YEA_JSON_PAIR IMPLEMENTATION.


  method constructor.
    me->_name  = name.
    me->_value = value.
  endmethod.


  method name.
    returning = me->_name.
  endmethod.


  method value.
    returning = me->_value.
  endmethod.
ENDCLASS.
