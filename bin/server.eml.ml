let show_form output request =
  
  <html>
  <body>

    <form method="POST" id="form">
      <%s! Dream.csrf_tag request %>
      <p>
      <input type="search" required="true" size="100"
        name="message" value=""
        onfocus="this.select();" autofocus>
      </p>
      <p>
      <input type="submit" value="search" id="search" name="search">
      </p>
    <%s! "Hello From " ^ output %>

  </html>
  </body>

let start () =
  let interface = "0.0.0.0" in
  let port = 8081 in
  Dream.run ~port ~interface
  @@ Dream.memory_sessions
  @@ Dream.logger
  @@ Dream.router [
       Dream.get "/testing_instance1" (fun req -> Dream.html (show_form "" req));
       Dream.post "/testing_instance1" (fun request -> match%lwt Dream.form request with
        | `Ok
          [ "message", from] -> 
            Dream.log "Receiving request %s" from;
            Dream.log "request csrf is %s!" (Dream.csrf_tag request);
            Dream.html (show_form from request)
        | _ -> Dream.empty `Bad_Request
        )
     ]