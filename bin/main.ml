open Core

let command =
  Command.basic ~summary:"Solve letter-boxed from a textfile"
    (let%map_open.Command groups = anon ("groups" %: string)
     and verbose = flag "v" no_arg ~doc:" increased verbosity" in
     fun () -> Letter_boxed.solve ~verbose groups)

let () = Command_unix.run ~version:"1.0" ~build_info:"letter-boxed" command
