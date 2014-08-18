<html>
    <head>
        <script src="/js/jquery.min.js"></script>
        
    </head>
    <body>
        <form id="myform" method="post" action="/application/auth/authenticate">
            <div><input type="submit" value="Submit"></div>
        </form>
        
        <div><input name="var_name" id="var_name_id"></div>
        <div><input name="var_value" id="var_value_id"></div>
        <div><input type="button" value="add param" id="add_var"></div>
        <script>
            $( document ).ready(function() {
                $('#add_var').click(function(){
                    $('#myform').prepend('<input type=hidden name="'+$('#var_name_id').val()+'" value="'+$('#var_value_id').val()+'">')
                    $('#var_name_id').val('');
                    $('#var_value_id').val('');
                });
            });
        </script>
    </body>
</html>