text_file = open("APS_mturk.txt", "a")

for i in range(1,121):
    text_file = open("APS_mturk_html.rtf", "a")
    image_text = "\n<fieldset>\n<div><img alt="image_url" class="imagecontainer" src="${image_url}" /></div>\n<div class="inputfields">\n<div class="form-group"><label>Description:</label> <input class="form-control" name="INPUT_1" required="" size="30" type="text" /></div>\n</div>\n</fieldset>"
    text_file.write(image_text % (i,i))