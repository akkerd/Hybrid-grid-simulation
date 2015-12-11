#ifndef __c4_Zigor_Model_h__
#define __c4_Zigor_Model_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_szlnHL9Df6pKpDV9xqQkSJG
#define struct_szlnHL9Df6pKpDV9xqQkSJG

struct szlnHL9Df6pKpDV9xqQkSJG
{
  real_T Ploss_off;
  real_T Ploss_on;
  real_T Eff_hl;
  real_T Eff_fl;
};

#endif                                 /*struct_szlnHL9Df6pKpDV9xqQkSJG*/

#ifndef typedef_c4_szlnHL9Df6pKpDV9xqQkSJG
#define typedef_c4_szlnHL9Df6pKpDV9xqQkSJG

typedef struct szlnHL9Df6pKpDV9xqQkSJG c4_szlnHL9Df6pKpDV9xqQkSJG;

#endif                                 /*typedef_c4_szlnHL9Df6pKpDV9xqQkSJG*/

#ifndef struct_sao7lvpULMJbzgO3vhk2pkD
#define struct_sao7lvpULMJbzgO3vhk2pkD

struct sao7lvpULMJbzgO3vhk2pkD
{
  real_T nPW;
  c4_szlnHL9Df6pKpDV9xqQkSJG Eff;
  real_T MinPVPW_On;
  real_T MinPVPW_av;
};

#endif                                 /*struct_sao7lvpULMJbzgO3vhk2pkD*/

#ifndef typedef_c4_sao7lvpULMJbzgO3vhk2pkD
#define typedef_c4_sao7lvpULMJbzgO3vhk2pkD

typedef struct sao7lvpULMJbzgO3vhk2pkD c4_sao7lvpULMJbzgO3vhk2pkD;

#endif                                 /*typedef_c4_sao7lvpULMJbzgO3vhk2pkD*/

#ifndef typedef_c4_ResolvedFunctionInfo
#define typedef_c4_ResolvedFunctionInfo

typedef struct {
  const char * context;
  const char * name;
  const char * dominantType;
  const char * resolved;
  uint32_T fileTimeLo;
  uint32_T fileTimeHi;
  uint32_T mFileTimeLo;
  uint32_T mFileTimeHi;
} c4_ResolvedFunctionInfo;

#endif                                 /*typedef_c4_ResolvedFunctionInfo*/

#ifndef typedef_SFc4_Zigor_ModelInstanceStruct
#define typedef_SFc4_Zigor_ModelInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c4_sfEvent;
  boolean_T c4_isStable;
  boolean_T c4_doneDoubleBufferReInit;
  uint8_T c4_is_active_c4_Zigor_Model;
} SFc4_Zigor_ModelInstanceStruct;

#endif                                 /*typedef_SFc4_Zigor_ModelInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c4_Zigor_Model_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c4_Zigor_Model_get_check_sum(mxArray *plhs[]);
extern void c4_Zigor_Model_method_dispatcher(SimStruct *S, int_T method, void
  *data);

#endif
