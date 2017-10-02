class YEA_JSON_PARSER definition
  public
  final
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods SERIALIZE
    importing
      !JSON type ref to YEA_JSON_VALUE
    returning
      value(RETURNING) type STRING .
  class-methods DESERIALIZE
    importing
      !STRING type STRING
    returning
      value(RETURNING) type ref to YEA_JSON_VALUE .
  class-methods ABAP_TO_JSON
    importing
      !DATA type ANY
      !STACK type YEA_OBJECT_STACK optional
    returning
      value(RETURNING) type ref to YEA_JSON_VALUE .
protected section.
private section.

  class-data _UTF8_CONVERTER type ref to CL_ABAP_CONV_OUT_CE .

  class-methods _SERIALIZE_NULL
    importing
      !NULL type ref to YEA_JSON_NULL
    returning
      value(RETURNING) type STRING .
  class-methods _SERIALIZE_BOOLEAN
    importing
      !BOOLEAN type ref to YEA_JSON_BOOLEAN
    returning
      value(RETURNING) type STRING .
  class-methods _SERIALIZE_STRING
    importing
      !STRING type ref to YEA_JSON_STRING
    returning
      value(RETURNING) type STRING .
  class-methods _SERIALIZE_NUMBER
    importing
      !NUMBER type ref to YEA_JSON_NUMBER
    returning
      value(RETURNING) type STRING .
  class-methods _SERIALIZE_ARRAY
    importing
      !ARRAY type ref to YEA_JSON_ARRAY
    returning
      value(RETURNING) type STRING .
  class-methods _SERIALIZE_OBJECT
    importing
      !OBJECT type ref to YEA_JSON_OBJECT
    returning
      value(RETURNING) type STRING .
  class-methods _UTF8_BYTE
    importing
      !CHAR type CHAR1
    returning
      value(RETURNING) type XSTRING .
ENDCLASS.



CLASS YEA_JSON_PARSER IMPLEMENTATION.


  method ABAP_TO_JSON.

    data(_stack) = stack.
    data name_bucket type string.
    data number_convert type float.
    data oref type ref to object.
    data json_res type ref to yea_json_value.
    data json_obj_cast type ref to yea_json_object.
    data json_arr_cast type ref to yea_json_array.
    field-symbols <table> type any table.
    field-symbols <oattr> type any.

    data(type_descr) = cast cl_abap_typedescr( cl_abap_typedescr=>describe_by_data( data ) ).

    " Boolean types
    if ( type_descr->type_kind = cl_abap_typedescr=>typekind_char and
         type_descr->absolute_name = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL' ).
      data boolean_cast type abap_bool.
      boolean_cast = data.
      returning = new yea_json_boolean( boolean_cast ).

    " Numbers
    elseif ( type_descr->type_kind = cl_abap_typedescr=>typekind_int or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int1 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int2 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int8 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_decfloat or
         type_descr->type_kind = cl_abap_typedescr=>typekind_decfloat16 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_decfloat34 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_float or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int1 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int2 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_int8 or
         type_descr->type_kind = cl_abap_typedescr=>typekind_num or
         type_descr->type_kind = cl_abap_typedescr=>typekind_numeric or
         type_descr->type_kind = cl_abap_typedescr=>typekind_packed ).
      returning = new yea_json_number( conv float( data ) ).

    " Text (Date fields are text)
    elseif ( type_descr->type_kind = cl_abap_typedescr=>typekind_char or
             type_descr->type_kind = cl_abap_typedescr=>typekind_csequence or
             type_descr->type_kind = cl_abap_typedescr=>typekind_string or
             type_descr->type_kind = cl_abap_typedescr=>typekind_date ).
      data(string_cast) = conv string( data ).
      replace all occurrences of '\' in string_cast with '\\'.
      replace all occurrences of '"' in string_cast with '\"'.
      returning = new yea_json_string( string_cast ).

    " Structures
    elseif ( type_descr->type_kind = cl_abap_typedescr=>typekind_struct1 or
             type_descr->type_kind = cl_abap_typedescr=>typekind_struct2 ).
      returning = new yea_json_object( ).
      json_obj_cast ?= returning.
      data(struct_descr) = cast cl_abap_structdescr(
        cl_abap_structdescr=>describe_by_data( data )
      ).
      loop at struct_descr->components assigning field-symbol(<cmp>).
        assign component <cmp>-name of structure data to field-symbol(<data>).
        json_res = yea_json_parser=>abap_to_json( data = <data> stack = stack ).
        name_bucket = conv string( <cmp>-name ).
        translate name_bucket to lower case.
        json_obj_cast->add(
          new yea_json_pair(
            name = name_bucket
            value = json_res
          )
        ).
      endloop.

    " Tables
    elseif ( type_descr->type_kind = cl_abap_typedescr=>typekind_table ).
      returning = new yea_json_array( ).
      json_arr_cast ?= returning.
      assign data to <table>.
      loop at <table> assigning field-symbol(<row>).
        json_res = yea_json_parser=>abap_to_json( data = <row> stack = stack ).
        json_arr_cast->append( json_res ).
      endloop.

    " Object reference
    elseif ( type_descr->type_kind = cl_abap_typedescr=>typekind_oref ).
      if ( data is bound ).
        returning = new yea_json_object( ).
        json_obj_cast ?= returning.
        oref = data.
        data(class_descr) = cast cl_abap_classdescr(
          cl_abap_classdescr=>describe_by_object_ref( oref )
        ).
        append oref to _stack.
        loop at class_descr->attributes assigning field-symbol(<attr>) where visibility = 'U'.
          assign oref->(<attr>-name) to <oattr>.
          " Don't add classes already in this stack
          read table stack with key table_line = oref transporting no fields.
          if ( sy-subrc = 0 ).
            continue.
          endif.
          json_res = yea_json_parser=>abap_to_json( data = <oattr> stack = _stack ).
          name_bucket = conv string( <attr>-name ).
          translate name_bucket to lower case.
          json_obj_cast->add(
            new yea_json_pair(
              name = name_bucket
              value = json_res
            )
          ).
        endloop.
      else.
        returning = new yea_json_null( ).
      endif.
    endif.

  endmethod.


  method CLASS_CONSTRUCTOR.
    _utf8_converter = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
  endmethod.


  method deserialize.

    data next type abap_bool.
    data state type c.
    data char type c.
    data number type f.
    data byte_value type xstring.
    data ap type i.

    data kv_mode type abap_bool value abap_true. " True is key
    data key_bucket type string.
    data number_bucket type string.

    data(position) = 0.
    data(limit) = strlen( string ).

    data top_ref type ref to yea_json_value.
    data co_ref type ref to yea_json_object.
    data ca_ref type ref to yea_json_array.
    data stack   type table of ref to yea_json_value.
    data prev_char type c.

    while position < limit.

      char = string+position(1).
      byte_value = _utf8_byte( char ).

      if ( byte_value <= '20' or ( byte_value >= '7F' and byte_value <= 'C2A0' ) ).

        position = position + 1.
        continue.
      endif.

      case char.
        when yea_json_types=>object_open. " '{'. " Object Open

          " Push new object
          data(new_object) = new yea_json_object( ).
          append new_object to stack.
          if ( top_ref is bound and top_ref->type( ) = yea_json_types=>type_array ).
            ca_ref ?= top_ref.
            ca_ref->append( new_object ).
          elseif ( top_ref is bound and top_ref->type( ) = yea_json_types=>type_object ) .
            co_ref ?= top_ref.
            if ( key_bucket is initial ).
              return.
            endif.
            co_ref->add( new yea_json_pair( name = key_bucket value = new_object ) ).
          endif.
          clear key_bucket.
          top_ref = new_object.
          state = '{'.

        when yea_json_types=>object_close. " '}'. " Object Close

          if ( state is initial ).
            return.
          endif.

          if ( state = ',' or state = ':' ).
            return.
          endif.

          " Pop top object
          data(pop_object) = stack[ lines( stack ) ].
          if ( lines( stack ) = 1 ).
            ap = position + 1.
            delete stack index lines( stack ).
            if ( lines( stack ) = 0 and ap < limit ).
              return.
            endif.
            exit.
          endif.
          delete stack index lines( stack ).
          read table stack index lines( stack ) into top_ref.
          state = '}'.

        when yea_json_types=>array_open. " Array Open

          " Push new array
          data(new_array) = new yea_json_array( ).
          append new_array to stack.
          if ( top_ref is bound and top_ref->type( ) = yea_json_types=>type_array ).
            ca_ref ?= top_ref.
            ca_ref->append( new_array ).
          elseif ( top_ref is bound and top_ref->type( ) = yea_json_types=>type_object ) .
            co_ref ?= top_ref.
            if ( key_bucket is initial ).
              return.
            endif.
            co_ref->add( new yea_json_pair( name = key_bucket value = new_array ) ).
          endif.
          clear key_bucket.
          top_ref = new_array.
          state = '['.

        when yea_json_types=>array_close. " Array Close

          if ( state is initial ).
            return.
          endif.

          if ( lines( stack ) = 0 ).
            return.
          endif.

          if ( state = ',' or state = ':' ).
            return.
          endif.

          " Pop top array
          data(pop_array) = stack[ lines( stack ) ].
          if ( lines( stack ) = 1 ).
            ap = position + 1.
            delete stack index lines( stack ).
            if ( lines( stack ) = 0 and ap < limit ).
              return.
            endif.
            exit.
          endif.
          delete stack index lines( stack ).
          read table stack index lines( stack ) into top_ref.
          state = ']'.

        when yea_json_types=>quote. " String Value
          " Scan to the next character
          data(escape) = abap_false.
          data(string_start) = position.
          while position < limit.
            position = position + 1.
            if ( position = limit ).
              return.
            endif.
            char = string+position(1).
            byte_value = _utf8_byte( char ).
            if ( escape = abap_true ).
              escape = abap_false.
              continue.
            elseif ( char = '\' ).
              escape = abap_true.
              continue.
            elseif ( char = '"' ).
              data result type string.
              data(delta) = ( position - string_start ).
              data(ns) = string_start + 1.
              data(nd) = delta - 1.
              result = string+ns(nd).
              exit.
            endif.
          endwhile.
          if ( state = ':' ).
            co_ref ?= top_ref.
            co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_string( result ) ) ).
            clear: key_bucket.
          elseif ( state = '[' ).
            ca_ref ?= top_ref.
            ca_ref->append( new yea_json_string( result ) ).
          elseif ( state = '{' or state = ',' ).
            case top_ref->type( ).
              when yea_json_types=>type_array.
                ca_ref ?= top_ref.
                ca_ref->append( new yea_json_string( result ) ).
              when yea_json_types=>type_object.
                key_bucket = result.
            endcase.
          else.
            return.
          endif.
          clear result.
          state = '"'.

        when yea_json_types=>colon. " ':'. " Key:Value Seperator
          if ( top_ref is bound and top_ref->type( ) <> yea_json_types=>type_object ).
            return.
          endif.

          if ( state <> '"' and state <> '[' ).
            return.
          endif.
          state = ':'.
        when yea_json_types=>comma. " ','. " Value Separator
          state = ','.
        when others.

          data(offset) = 0.
          data(outlen) = position.
          if ( char = 't' or char = 'n' ).
            outlen = position + 4.
          elseif ( char = 'f' ).
            outlen = position + 5.
          endif.
          if ( outlen > limit ).
            return.
          endif.
          if ( char co '-+.0123456789Etfn' ).
          else.
            " Not allowed
            return.
          endif.
          if ( limit > ( position + 4 ) and string+position(4) = 'true' ).
            position = position + 3.
            if ( state = ':' ).
              co_ref ?= top_ref.
              co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_boolean( abap_true ) ) ).
              clear key_bucket.
            elseif ( state = '[' ).
              ca_ref ?= top_ref.
              ca_ref->append( new yea_json_boolean( abap_true ) ).
            elseif ( state = ',' ).
              case top_ref->type( ).
                when yea_json_types=>type_object.
                  co_ref ?= top_ref.
                  co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_boolean( abap_true ) ) ).
                  clear key_bucket.
                when yea_json_types=>type_array.
                  ca_ref ?= top_ref.
                  ca_ref->append( new yea_json_boolean( abap_true ) ).
              endcase.
            endif.

          elseif ( limit > ( position + 5 ) and string+position(5) = 'false' ).
            position = position + 4.
            if ( state = ':' ).
              co_ref ?= top_ref.
              co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_boolean( abap_false ) ) ).
              clear key_bucket.
            elseif ( state = '[' ).
              ca_ref ?= top_ref.
              ca_ref->append( new yea_json_boolean( abap_false ) ).
            elseif ( state = ',' ).
              case top_ref->type( ).
                when yea_json_types=>type_object.
                  co_ref ?= top_ref.
                  co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_boolean( abap_false ) ) ).
                  clear key_bucket.
                when yea_json_types=>type_array.
                  ca_ref ?= top_ref.
                  ca_ref->append( new yea_json_boolean( abap_false ) ).
              endcase.
            endif.
          elseif ( limit > ( position + 4 ) and string+position(4) = 'null' ).
            position = position + 3.
            if ( state = ':' ).
              co_ref ?= top_ref.
              co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_null( ) ) ).
              clear key_bucket.
            elseif ( state = '[' ).
              ca_ref ?= top_ref.
              ca_ref->append( new yea_json_null( ) ).
            elseif ( state = ',' ).
              case top_ref->type( ).
                when yea_json_types=>type_object.
                  co_ref ?= top_ref.
                  co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_null( ) ) ).
                  clear key_bucket.
                when yea_json_types=>type_array.
                  ca_ref ?= top_ref.
                  ca_ref->append( new yea_json_null( ) ).
              endcase.
            endif.
          elseif ( char co '-+.0123456789E' ).
            " Scan until next value isn't a digit
            number_bucket = char.
            while position < limit.
              position = position + 1.
              if ( position >= limit ).
                return.
              endif.

              char = string+position(1).
              byte_value = _utf8_byte( char ).
              if ( char co '-+.0123456789E' ).
                number_bucket = number_bucket && char.
              else.
                exit.
              endif.
            endwhile.
            number = number_bucket.
            if ( state = ':' ).
              co_ref ?= top_ref.
              co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_number( number ) ) ).
              clear key_bucket.
            elseif ( state = '[' ).
              ca_ref ?= top_ref.
              ca_ref->append( new yea_json_number( number ) ).
            elseif ( state = ',' ).
              case top_ref->type( ).
                when yea_json_types=>type_object.
                  if ( key_bucket is initial ).
                    return.
                  endif.
                  co_ref ?= top_ref.
                  co_ref->add( new yea_json_pair( name = key_bucket value = new yea_json_number( number ) ) ).
                  clear key_bucket.
                when yea_json_types=>type_array.
                  ca_ref ?= top_ref.
                  ca_ref->append( new yea_json_number( number ) ).
              endcase.
            endif.
            position = position - 1.
          else.
            return.
          endif.
          state = '+'.
      endcase.
      position = position + 1.
    endwhile.
    if ( lines( stack ) = 0 and key_bucket is initial ).
      returning = top_ref.
    endif.
  endmethod.


  method serialize.
    data(type) = json->type( ).
    case type.
      when yea_json_types=>type_null.
        returning = _serialize_null( cast yea_json_null( json ) ).
      when yea_json_types=>type_boolean.
        returning = _serialize_boolean( cast yea_json_boolean( json ) ).
      when yea_json_types=>type_number.
        returning = _serialize_number( cast yea_json_number( json ) ).
      when yea_json_types=>type_string.
        returning = _serialize_string( cast yea_json_string( json ) ).
      when yea_json_types=>type_array.
        returning = _serialize_array( cast yea_json_array( json ) ).
      when yea_json_types=>type_object.
        returning = _serialize_object( cast yea_json_object( json ) ).
    endcase.
  endmethod.


  method _serialize_array.
    data(size) = array->size( ).
    data(index) = 1.
    data output type string.
    do size times.
      data(el) = array->get( index ).
      data(el_text) = serialize( el ).
      if ( index = size ).
        output = output && el_text.
      else.
        output = output && el_text && ','.
      endif.
      index = index + 1.
    enddo.
    returning = '[' && output && ']'.
  endmethod.


  method _SERIALIZE_BOOLEAN.
    case boolean->get( ).
      when abap_true.
        returning = 'true'.
      when others.
        returning = 'false'.
    endcase.
  endmethod.


  method _SERIALIZE_NULL.
    returning = 'null'.
  endmethod.


  method _SERIALIZE_NUMBER.
    " there has to be a better way
    data pck_f(16) type p decimals 8.
    data pck_w(16) type p decimals 0.
    data(flt) = number->get( ).
    pck_f = flt.
    pck_w = trunc( pck_f ).
    if ( flt > pck_w and flt > 0 ).
      returning = pck_f.
    elseif ( flt < pck_w and flt < 0 ).
      returning = pck_f.
    else.
      returning = pck_w.
    endif.
    shift returning right deleting trailing space.
    shift returning left deleting leading space.
    shift returning right deleting trailing '0'.
    shift returning left deleting leading '0'.
    shift returning right deleting trailing space.
    shift returning left deleting leading space.
  endmethod.


  method _SERIALIZE_OBJECT.
    data tpl type string value '"%1":%2'.
    data template type string.
    data(keys) = object->keys( ).
    data json_pairs type stringtab.
    loop at keys assigning field-symbol(<key>).
      data(pair) = object->pair( <key> ).
      template = tpl.
      replace first occurrence of '%1' in template with pair->name( ).
      replace first occurrence of '%2' in template with serialize( pair->value( ) ).
      append template to json_pairs.
    endloop.
    data(index) = 1.
    data output_line type string.
    do lines( keys ) times.
      read table json_pairs index index assigning field-symbol(<jp>).
      if ( index = lines( keys ) ).
        output_line = output_line && <jp>.
      else.
        output_line = output_line && <jp> && ','.
      endif.
      index = index + 1.
    enddo.
    returning = '{' && output_line && '}'.
  endmethod.


  method _serialize_string.
    data(str_out) = string->get( ).
    returning = '"' && str_out && '"'.
  endmethod.


  method _UTF8_BYTE.
    _utf8_converter->reset( ).
    _utf8_converter->write( data = char ).
    returning = _utf8_converter->get_buffer( ).
  endmethod.
ENDCLASS.
