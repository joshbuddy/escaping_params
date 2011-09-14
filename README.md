# Escaping params

## A CRAZY idea

    require 'escaping_params'
    require 'erb'
    
    params = {:a => "<b>I'm deadly!</b>"}
    
    puts ERB.new("Hey, <%=params[:a]%>").result(binding)
    # Hey, <b>I'm deadly!</b>

    params.extend(EscapingParams)
    
    puts ERB.new("Hey, <%=params[:a]%>").result(binding)
    # Hey, &lt;b&gt;I'm deadly!&lt;/b&gt;
