 #!/bin/bash

gnome-terminal -x sh -c "ssh eos \"ls 
	./hello.sh
\"; bash"
echo "done ssh"
