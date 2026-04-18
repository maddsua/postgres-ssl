## WHY?

Because almost every time I needed postgres I also used it over a public network which demands securing your damn connections.

Until now I've used the railway/postgres-ssl image, which is okay. The annoying part with it is that it's tailored to run well-enough on railway, which I am not even using anymore.

A bigger issue, however, is that it has a tendency to get killed by podman every time you request to stop it, as they seem to have forgotten to handle signals in their wrapper script.

And I am not sure that you can fix their image without completely rewriting the thing. So yeah, here it is, my custom image. Enjoy!
