#include <core.p4>
#if __TARGET_TOFINO__ == 3
#include <t3na.p4>
#elif __TARGET_TOFINO__ == 2
#include <t2na.p4>
#else
#include <tna.p4>
#endif

#include "headers.p4"
#include "parser.p4"


/* ===================================================== Ingress ===================================================== */


control SwitchIngress(
    /* User */
    inout header_t      hdr,
    inout metadata_t    meta,
    /* Intrinsic */
    in ingress_intrinsic_metadata_t                     ig_intr_md,
    in ingress_intrinsic_metadata_from_parser_t         ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t     ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t           ig_tm_md)
{
    Register<bit<32>, bit<1>>(4) secret_values;
    //Register<bit<32>, bit<1>>(1) secret_values2;
    //Register<bit<32>, bit<1>>(1) secret_values3;
    //Register<bit<32>, bit<1>>(1) secret_values4;

    /* Forward */
    action hit(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;
    }

    action miss(bit<3> drop) {
        ig_dprsr_md.drop_ctl = drop;
    }

    action guardar_token(bit<32> t1, bit<32> t2, bit<32> t3, bit<32> t4) {
        /*secret_values1.write(0, t1);
        secret_values2.write(0, t2);
        secret_values3.write(0, t3);
        secret_values4.write(0, t4);*/
    }

    action carregar_token() {
        meta.aux1 = secret_values.read(0);

    }

    table forward {
        key = {
            hdr.ethernet.dst_addr : exact;
        }

        actions = {
            hit;
            @defaultonly miss;
        }

        const default_action = miss(0x1);
        size = 1024;
    }


    /* 
    Cria um registrador no formato:
        Register <tipo de dado armazenado, tamanho do indexador> (quantas entradas)
    No caso abaixo cria um registrador com uma entrada, indexado por 1 bit e valores de 32 bits.
    DICA: o mesmo registrador não pode ser acessado mais de uma vez por pacote, e armazenam valores
    de no máximo 32 bits, utilize multiplos registradores
    */

    apply {
        /* Realiza roteamento MAC. Não excluir */
        forward.apply();

        /*
        Para ler um registrador:
            secret_values.read(index);

        Para escrever:
            secret_values.write(index, value);

        Para dropar um pacote:
            ig_dprsr_md.drop_ctl = 1;
        */

    if(hdr.segredo.isValid()) {
        if(hdr.segredo.operacao == 1) {
            guardar_token(hdr.segredo.token[31:0], hdr.segredo.token[63:32], hdr.segredo.token[95:64], hdr.segredo.token[127:96]);
        
        } else if(hdr.segredo.operacao == 0) {

            carregar_token();
        }

        // if too complex bruh
        if (!(meta.aux1 == hdr.segredo.token[31:0]
        )) 
        {
            ig_dprsr_md.drop_ctl = 1;
        }
    } else {
        ig_dprsr_md.drop_ctl = 1;
        }


    }
}

/* ===================================================== Egress ===================================================== */

control SwitchEgress(
    /* User */
    inout header_t      hdr,
    inout metadata_t    meta,
    /* Intrinsic */
    in egress_intrinsic_metadata_t                      eg_intr_md,
    in egress_intrinsic_metadata_from_parser_t          eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t      eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t   eg_oport_md)
{
    apply {}
}


/* ===================================================== Final Pipeline ===================================================== */
Pipeline(
    SwitchIngressParser(),
    SwitchIngress(),
    SwitchIngressDeparser(),
    SwitchEgressParser(),
    SwitchEgress(),
    SwitchEgressDeparser()
) pipe;

Switch(pipe) main;
