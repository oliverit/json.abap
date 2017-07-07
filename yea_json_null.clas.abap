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


  method yea_json_value~type.
    returning = yea_json_types=>type_null.
  endmethod.
ENDCLASS.
