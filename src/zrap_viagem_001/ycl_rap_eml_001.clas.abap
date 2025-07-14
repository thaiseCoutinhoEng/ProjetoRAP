CLASS ycl_rap_eml_001 DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS:
      metodo_read   IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      metodo_create IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      metodo_update IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out,
      metodo_delete IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS ycl_rap_eml_001 IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.

    " Execução de ações de leitura.
    "me->metodo_read( io_out = out ).

    " Execução de ações de criação
    "me->metodo_create( io_out = out ).

    " Execução de ações de modificação
    "me->metodo_update( io_out = out ).

    " Execução de ações de exclusão
    me->metodo_delete( io_out = out ).

  ENDMETHOD.

  METHOD metodo_read.

    " Seleção simples utilizando EML
    "READ ENTITIES OF yi_viagem_0001
    "  ENTITY Viagem
    "    FROM VALUE #( ( ViagemUUID = '994839E229B791571900FDE605BA7F5C' ) )
    "  RESULT DATA(lt_viagens).

    "io_out->write( lt_viagens ).

    " Seleção definindo os campos requeridos
    "READ ENTITIES OF yi_viagem_0001
    "  ENTITY Viagem
    "    FIELDS ( AgenciaID ClienteID )
    "    WITH VALUE #( ( ViagemUUID = '994839E229B791571900FDE605BA7F5C' ) )
    "  RESULT DATA(lt_viagens).

    "io_out->write( lt_viagens ).

    " Seleção de todos os campos
    "READ ENTITIES OF yi_viagem_0001
    "  ENTITY Viagem
    "    ALL FIELDS
    "    WITH VALUE #( ( ViagemUUID = '994839E229B791571900FDE605BA7F5C' ) )
    "  RESULT DATA(lt_viagens).

    "io_out->write( lt_viagens ).

    " Seleção por associação e exposição de erros e falhas
    READ ENTITIES OF yi_viagem_001
      ENTITY Viagem BY \_Reserva
        ALL FIELDS
        WITH VALUE #( ( ViagemUUID = '994839E229B791571900FDE605BA7F5D' ) )
      RESULT DATA(lt_reservas)
      FAILED DATA(ls_falhas)
      REPORTED DATA(ls_mensagens).

    io_out->write( lt_reservas ).
    io_out->write( ls_falhas ).
    io_out->write( ls_mensagens ).

  ENDMETHOD.

  METHOD metodo_create.

    " Criação de uma viagem
    MODIFY ENTITIES OF yi_viagem_001
      ENTITY Viagem
       CREATE
         SET FIELDS WITH VALUE
          #( (  %cid       = '204'
                ViagemID   = '204'
                AgenciaID  = '070020'
                ClienteID  = '000615'
                DataInicio = cl_abap_context_info=>get_system_date( )
                DataFim    = cl_abap_context_info=>get_system_date( ) + 10
                Descricao  = 'Eu gosto de RAP'  ) )
      MAPPED DATA(ls_campos_mapeados)
      FAILED DATA(ls_falhas_criacao)
      REPORTED DATA(ls_mensagens_criacao).

    COMMIT ENTITIES
      RESPONSE OF yi_viagem_001
      FAILED DATA(ls_falhas_commit)
      REPORTED DATA(ls_mensagens_commit).

    io_out->write( ls_campos_mapeados-viagem ).

  ENDMETHOD.

  METHOD metodo_update.

    " Utilização de modificação

    MODIFY ENTITIES OF yi_viagem_001
      ENTITY Viagem
       UPDATE
          SET FIELDS WITH VALUE
             #( ( ViagemUUID = 'E65FD4A88F001FE090B438BAF844A86C'
                  Descricao  = 'Eu amo codificar em rap' ) )
       FAILED DATA(ls_falhas_update)
       REPORTED DATA(ls_mensagens_update).

    COMMIT ENTITIES
       RESPONSE OF yi_viagem_001
       FAILED   DATA(ls_falhas_commit)
       REPORTED DATA(ls_mensagens_commit).

    io_out->write( 'Atualização concluída'  ).

  ENDMETHOD.

  METHOD metodo_delete.

    " Operação de exclusão
    MODIFY ENTITIES OF yi_viagem_001
      ENTITY Viagem
       DELETE FROM
        VALUE #( ( ViagemUUID = 'E65FD4A88F001FE090B438BAF844A86C' ) )
      FAILED   DATA(ls_falhas_delete)
      REPORTED DATA(ls_mensagens_delete).

    COMMIT ENTITIES
      RESPONSE OF yi_viagem_001
      FAILED DATA(ls_falhas_commit)
      REPORTED DATA(ls_mensagens_commit).

    io_out->write( 'Exclusão realizada.' ).

ENDMETHOD.

ENDCLASS.

" - Desenvolvimento de determinação
*determination calcularViagemID on save { create; }
*
*METHOD calcularViagemID.
*
*    READ ENTITIES OF yi_viagem_0001 IN LOCAL MODE
*      ENTITY Viagem
*        FIELDS ( ViagemID ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_viagens).
*
*    DELETE lt_viagens WHERE ViagemID IS NOT INITIAL.
*
*    CHECK lt_viagens IS NOT INITIAL.
*
*    SELECT SINGLE
*       FROM yi_viagem_0001
*       FIELDS MAX( ViagemID )
*       INTO @DATA(lv_maior_id).
*
*    " Modificando o ID da viagem
*    MODIFY ENTITIES OF yi_viagem_0001 IN LOCAL MODE
*      ENTITY Viagem
*        UPDATE
*          FROM VALUE #( FOR <ls_viagem> IN lt_viagens INDEX INTO lv_index
*                         ( %tky     = <ls_viagem>-%tky
*                           ViagemID = lv_maior_id + lv_index
*                           %control-ViagemID = if_abap_behv=>mk-on ) )
*      REPORTED DATA(ls_viagem_id_mensagens).
*
*    reported = CORRESPONDING #( DEEP ls_viagem_id_mensagens ).
*
*  ENDMETHOD.

