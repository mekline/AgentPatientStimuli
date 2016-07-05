text_file = open("APS_test.rtf", "a")

for i in range(1,121):
    text_file = open("APS_mturk_html.rtf", "a")
    image_text = "\n\n<fieldset>\n<p><img alt='image_url' class='imagecontainer' src='${IMAGE_%s}' style='opacity: 0.9; font-size: 11.7px; line-height: 20.8px;'' /></p>\n<div class='inputfields'>\n<p>&nbsp;</p>\n<p>&nbsp;</p>\n<p>&nbsp;</p>\n<p>&nbsp;</p>\n<div class='form-group'><b>Description:</b><br />\n<input class='form-control' name='NumberOfItems' id='${INPUT_%d}' required='' size='30' type='text' /></div>\n</div>\n</fieldset>\n<!-----Trial end--><!-- End Instructions --></div>"
    text_file.write(image_text % (i,i))