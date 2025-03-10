resource "apstra_configlet" "junos_sflow" {
name = "junos_sflow"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
protocols {
    sflow {
        polling-interval 5;
        source-ip {{management_ip}};
        sample-rate {
            ingress 1000;
            egress 1000;
        }
        collector 10.10.10.2 {
            udp-port 6343;
        }
        interfaces xe-0/0/0.0;
        interfaces xe-0/0/1.0;
        interfaces xe-0/0/2.0;
        interfaces xe-0/0/3.0;
        interfaces xe-0/0/4.0;
        interfaces xe-0/0/5.0;
        interfaces xe-0/0/6.0;
        interfaces xe-0/0/7.0;
        interfaces xe-0/0/8.0;
        interfaces xe-0/0/9.0;
        interfaces xe-0/0/10.0;
        interfaces xe-0/0/11.0;
    }
}
routing-options {
    static {
        route 10.10.10.2/32 next-table mgmt_junos.inet.0;
    }
}
EOT

},
]

}