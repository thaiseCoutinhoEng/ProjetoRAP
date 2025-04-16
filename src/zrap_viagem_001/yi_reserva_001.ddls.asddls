@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reserva BO'
define view entity YI_RESERVA_001
  as select from ytreservas_001 as Reserva

  //Pai - Viagem
  association to parent YI_VIAGEM_001 as _Viagem    on  $projection.ViagemUUID = _Viagem.ViagemUUID

  association [1..1] to /DMO/I_Customer   as _Cliente   on  $projection.ClienteID = _Cliente.CustomerID
  association [1..1] to /DMO/I_Carrier    as _Operadora on  $projection.OperadoraID = _Operadora.AirlineID
  association [1..1] to /DMO/I_Connection as _Conexao   on  $projection.OperadoraID = _Conexao.AirlineID
                                                        and $projection.ConexaoID   = _Conexao.ConnectionID
  association [1..1] to /DMO/I_Flight     as _Voo       on  $projection.OperadoraID = _Voo.AirlineID
                                                        and $projection.ConexaoID   = _Voo.ConnectionID
                                                        and $projection.DataVoo     = _Voo.FlightDate
  association [0..1] to I_Currency        as _Moeda     on  $projection.CodigoMoeda = _Moeda.Currency

{
  key reserva_uuid                 as ReservaUUID,
      viagem_uuid                  as ViagemUUID,
      reserva_id                   as ReservaID,
      data_reserva                 as DataReserva,
      cliente_id                   as ClienteID,
      operadora_id                 as OperadoraID,
      conexao_id                   as ConexaoID,
      data_voo                     as DataVoo,
      @Semantics.amount.currencyCode: 'CodigoMoeda'
      preco_voo                    as PrecoVoo,
      codigo_moeda                 as CodigoMoeda,
      @Semantics.user.createdBy: true
      criado_por                   as CriadoPor,
      @Semantics.user.lastChangedBy: true
      ultima_modificacao_por       as UltimaModificacaoPor,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ultima_modificacao_por_local as UltimaModificacaoPorLocal,

      /* Associações */
      _Viagem,
      _Cliente,
      _Operadora,
      _Conexao,
      _Voo,
      _Moeda
}
