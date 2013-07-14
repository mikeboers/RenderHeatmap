Render Stat Heatmaps
====================


Questions
---------

- Can we have AOVs out of every render method? E.g. displacement, prelighting, etc..



TODO
----

- automatic shader composer via RIB Filter and co-shaders
  - use sloinfo (or API) to get a list of methods to make a standin for the
    shader.
  - use sloinfo (or API) to get the shader defaults, since some of them have
    special significance
  - replace all Surface calls with a Shader call, and a new Surface to the
    interposer
  - time everything, and store the duration in an output variable
  - create a output driver which saves the shadingDuration variable, ideally
    as a deep image

- heat-map of shader execution time
  - time_current() shadeop
  - time_sleep() shadeop to test it with

- tool to sum depth contributions

- examples
  - spheres
  - spheres with a delay
  - ambient occlusion
  - effect of shading rate
