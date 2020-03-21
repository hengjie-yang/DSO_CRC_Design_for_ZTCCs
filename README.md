# DSO_CRC_Design_for_ZTCCs
This repository provides tools to design the distance-spectrum-optimal (DSO) CRC generator polynomial for a given rate-*1/n* zero terminated convolutional code (ZTCC).

## Design steps
  1. run "find_dominant_error_event_fast.m" to generate all error events of distance bounded by 'd_tilde'. This will generate a .mat file starting with "error_event_"
  2. run "find_DSO_CRC_by_exclusion.m" to search for the degree-m DSO CRC generator polynomial for the given CC.
 
## Notes:
  1. Please refer to the input/output specifications inside each .m file
  2. The first step only needs to be implemented once as long as the CRC design is for the same ZTCC.
  2. Typically, we would choose d_tilde in between *2d_free* and *3d_free*.
  3. Current program only considers at most double undetectable error events. If the desired CRC degree is too large, one needs to consider triple or *n*-tuple *(n>2)* undetectable error events.
  
## Examples:

  Assume that the CC is given by (13, 17), the length of information sequence *k = 256*,  the CRC degree *m = 6*. Therefore, the degree-6 DSO CRC for the (13, 17) ZTCC with *k = 256* can be found by executing the following commands:
  ```
    find_dominant_error_event_fast(4, [13, 17], 20)
    find_DSO_CRC_by_exclusion(4, [13, 17], 20, 256, 6)
  ``` 
 Eventually, the degree-*6* DSO CRC generator polynomial is displayed in the command window: '103'

## References:

  [1] C. Y. Lou, B. Daneshrad, and R. D. Wesel, “Convolutional-code-specific CRC code design,” IEEE Trans. Commun., vol. 63,  no. 10, pp. 3459– 3470, Oct. 2015.
