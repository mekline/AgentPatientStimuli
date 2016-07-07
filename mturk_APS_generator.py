for i in range(1,121):
    text_file = open("APS_mturk.txt", "a")
    image_text = '\n<fieldset>\n<div><img alt="${IMAGE_%s}" class="imagecontainer" src="${image_url}" /></div>\n<div class="inputfields">\n<div class="form-group"><label>Description:</label> <input class="form-control" name="INPUT_%d" required="" size="30" type="text" /></div>\n</div>\n</fieldset>\n'
    text_file.write(image_text % (i,i))