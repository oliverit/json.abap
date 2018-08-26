class yea_json_null definition
  public
  final
  create public .

  public section.

    interfaces yea_json_value .
  protected section.
  private section.
ENDCLASS.



CLASS YEA_JSON_NULL IMPLEMENTATION.


  method YEA_JSON_VALUE~EQUAL.
    if ( me->yea_json_value~type( ) = object->type( ) ).
      returning = abap_true.
    endif.
  endmethod.


  method yea_json_value~type.
    returning = yea_json_types=>type_null.
  endmethod.
ENDCLASS.
