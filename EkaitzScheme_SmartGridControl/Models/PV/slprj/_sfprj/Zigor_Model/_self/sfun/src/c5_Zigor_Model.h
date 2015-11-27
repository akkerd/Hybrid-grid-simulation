#ifndef __c5_Zigor_Model_h__
#define __c5_Zigor_Model_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_sCKvBU3U0z4KB0OM7v1DGpC
#define struct_sCKvBU3U0z4KB0OM7v1DGpC

struct sCKvBU3U0z4KB0OM7v1DGpC
{
  real_T tilt;
  real_T SO;
};

#endif                                 /*struct_sCKvBU3U0z4KB0OM7v1DGpC*/

#ifndef typedef_c5_sCKvBU3U0z4KB0OM7v1DGpC
#define typedef_c5_sCKvBU3U0z4KB0OM7v1DGpC

typedef struct sCKvBU3U0z4KB0OM7v1DGpC c5_sCKvBU3U0z4KB0OM7v1DGpC;

#endif                                 /*typedef_c5_sCKvBU3U0z4KB0OM7v1DGpC*/

#ifndef struct_saSOdeh07LmZXv3qQ5udJsG
#define struct_saSOdeh07LmZXv3qQ5udJsG

struct saSOdeh07LmZXv3qQ5udJsG
{
  c5_sCKvBU3U0z4KB0OM7v1DGpC Orientation;
  real_T insPwPV;
  real_T TempPcoeffPV;
  real_T NOCT;
  real_T Kl;
  real_T Albedo;
};

#endif                                 /*struct_saSOdeh07LmZXv3qQ5udJsG*/

#ifndef typedef_c5_saSOdeh07LmZXv3qQ5udJsG
#define typedef_c5_saSOdeh07LmZXv3qQ5udJsG

typedef struct saSOdeh07LmZXv3qQ5udJsG c5_saSOdeh07LmZXv3qQ5udJsG;

#endif                                 /*typedef_c5_saSOdeh07LmZXv3qQ5udJsG*/

#ifndef typedef_c5_ResolvedFunctionInfo
#define typedef_c5_ResolvedFunctionInfo

typedef struct {
  const char * context;
  const char * name;
  const char * dominantType;
  const char * resolved;
  uint32_T fileTimeLo;
  uint32_T fileTimeHi;
  uint32_T mFileTimeLo;
  uint32_T mFileTimeHi;
} c5_ResolvedFunctionInfo;

#endif                                 /*typedef_c5_ResolvedFunctionInfo*/

#ifndef typedef_SFc5_Zigor_ModelInstanceStruct
#define typedef_SFc5_Zigor_ModelInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c5_sfEvent;
  boolean_T c5_isStable;
  boolean_T c5_doneDoubleBufferReInit;
  uint8_T c5_is_active_c5_Zigor_Model;
} SFc5_Zigor_ModelInstanceStruct;

#endif                                 /*typedef_SFc5_Zigor_ModelInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c5_Zigor_Model_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c5_Zigor_Model_get_check_sum(mxArray *plhs[]);
extern void c5_Zigor_Model_method_dispatcher(SimStruct *S, int_T method, void
  *data);

#endif
