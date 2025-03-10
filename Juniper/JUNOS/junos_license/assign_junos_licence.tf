resource "apstra_configlet" "assign_junos_licence" {
name = "assign_junos_licence"
generators = [
{
	config_style = "junos" 
	section = "top_level_hierarchical" 
	template_text = <<-EOT
system {
  license {
    keys {
      key "E20191218001 AAAAAA BBBBB CCCCC DDDDD EEEEE FFFFF GGGGG HHHHH IIIII JJJJJJ KKKKKK LLLLLL MMMMMM NNNNN OOOOO PPPPP RRRRR SSSSS TTTTT UUUUU";
    }
  }
}
EOT

},
]

}