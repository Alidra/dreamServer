let show_form output csrf_tag =
  
  <html>
  <body>

    <form method="POST" id="form">
      <%s! csrf_tag %>
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
       Dream.get "/testing_instance1" (fun req ->
        let csrf_tag = Dream.csrf_tag req in
        Dream.log "GET request scrf is : %s! " csrf_tag;
        Dream.html (show_form "" csrf_tag));
       Dream.post "/testing_instance1" (fun request ->
        let csrf_tag = Dream.csrf_tag request in
        Dream.log "POST request scrf is : %s! " csrf_tag;
        match%lwt Dream.form request with
        | `Ok
          ["message", name; "search", _second] -> 
            (* Dream.log "Receiving request %s" (string_of_int (List.length [firstT, first; secondT, second])); *)
            Dream.html (show_form name csrf_tag)
        (* | `OK [_, from ] -> Dream.html ("something went wrong" ^ from) *)
        | _ -> Dream.empty `Bad_Request
        )
     ]