Render Stat Heatmaps
====================


TODO
----

- time output should be color(start_time, duration, random())
- copy output variables from wrapped; when does this need to happen?
- tool to sum depth contributions
  - calculate floats
  - determine min/max, and range into 0 to 1
  - skip points that match previous ones, except in depth
    - std::set of 3-tuples of floats

- examples
  - spheres
  - spheres with a delay
  - ambient occlusion
  - effect of shading rate
