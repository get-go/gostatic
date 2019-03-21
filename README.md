[![Build Status](https://travis-ci.org/get-go/gostatic.svg?branch=master)](https://travis-ci.org/get-go/gostatic)

[![](https://images.microbadger.com/badges/image/getgo/gostatic.svg)](https://microbadger.com/images/getgo/gostatic "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/getgo/gostatic.svg)](https://microbadger.com/images/getgo/gostatic "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/getgo/gostatic:latest-example.svg)](https://microbadger.com/images/getgo/gostatic:latest-example "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/getgo/gostatic:latest-example.svg)](https://microbadger.com/images/getgo/gostatic:latest-example "Get your own version badge on microbadger.com")

**Original Intent** 
Use this Dockerfile as the base for future layers, allowing for simple to mildly complex Go applications to be statically compiled and run from a very minimalistic container. The result was a container starting as small as 5MB. I made a few projects based on this idea and method. Basically jamming everything into one long `ONBUILD` command, allowing you to add and remove all within one layer.

**Update**

As I go to update this repository to the newest versions of Alpine and Go and realized this problem has already been solved, making this repository obsolete.

So I try to update to Alpine 3.9 alone, and I get

```
ERROR: unsatisfiable constraints:
  go-1.11.5-r0:
    breaks: world[go=1.6.3-r0]
```

Well that version of go is pretty old. So then I'll update Go to 1.11.5-r0. I didn't need musl before, but adding `alpine-sdk` fixes this error:

```
/usr/lib/go/pkg/tool/linux_amd64/link: running gcc failed: exit status 1
/usr/lib/gcc/x86_64-alpine-linux-musl/8.2.0/../../../../x86_64-alpine-linux-musl/bin/ld: cannot find Scrt1.o: No such file or directory
/usr/lib/gcc/x86_64-alpine-linux-musl/8.2.0/../../../../x86_64-alpine-linux-musl/bin/ld: cannot find crti.o: No such file or directory
/usr/lib/gcc/x86_64-alpine-linux-musl/8.2.0/../../../../x86_64-alpine-linux-musl/bin/ld: cannot find -lssp_nonshared
collect2: error: ld returned 1 exit status
```
I get a `loadinternal: cannot find runtime/cgo` error, so I add `-installsuffix cgo`. I get a working image created, and it only went up to 9.86MB.

So the reason this is now obsolete, is for [Docker Multistage Builds](https://docs.bitnami.com/containers/how-to/optimize-docker-images-multistage-builds/). As I look into this new feature, I find it was based on [this pull request]( https://github.com/moby/moby/pull/31257) and at the time of the pull request, was supposedly a [bleeding edge feature](https://blog.alexellis.io/mutli-stage-docker-builds/). That pull request was made on Feb 22 2017, and my code here was a full 8 months before that feature was proposed. Docker Multistage Builds are a much more elegant solution, but that's why this project will no longer be maintained.

