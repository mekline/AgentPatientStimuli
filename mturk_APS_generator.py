text_file = open("APS_test.rtf", "a")
beginning_text = "<!-- Bootstrap v3.0.3 -->
<link href="https://s3.amazonaws.com/mturk-public/bs30/css/bootstrap.min.css" rel="stylesheet" />
<section class="container" id="TranscriptionFromAnImage" style="margin-bottom:15px; padding: 10px 10px; font-family: Verdana, Geneva, sans-serif; color:#333333; font-size:0.9em;">
<div class="row col-xs-12 col-md-12"><!-- Instructions -->
<div class="panel panel-primary">
<div class="panel-heading"><strong>Instructions</strong></div>

<div class="panel-body">
<p>Describe what you see in each&nbsp;image (one or two sentences is fine).</p>
</div>
</div>
<!-- End Instructions -->"

for i in range(1,121):
    print i
    text_file = open("APS_test.rtf", "a")
    image_text = "<fieldset>
<p><img alt="image_url" class="imagecontainer" src="http://tedlab.mit.edu/~mekline/AP062016/Agent_flipped_3.jpg" style="opacity: 0.9; font-size: 11.7px; line-height: 20.8px;" /></p>

<div class="inputfields">
<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<div class="form-group"><b>Description:</b><br />
<input class="form-control" name="NumberOfItems" required="" size="30" type="text" /></div>
</div>
</fieldset>
<!-----Trial end--><!-- End Instructions --></div>"

    text_file.write("\nImage number: %s" % i)