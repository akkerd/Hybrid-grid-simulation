/* Include files */

#include "blascompat32.h"
#include "Zigor_Model_sfun.h"
#include "c5_Zigor_Model.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "Zigor_Model_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c5_debug_family_names[10] = { "Param", "IrrDirect",
  "IrrDiffuse", "Elevation", "Azimuth", "Tair", "nargin", "nargout", "u",
  "P_Solar" };

static const char * c5_b_debug_family_names[4] = { "nargin", "nargout",
  "angleInDegrees", "angleInRadians" };

static const char * c5_c_debug_family_names[14] = { "FA", "Ai", "FAd", "FAr",
  "Tcell", "nargin", "nargout", "Param", "IrrExtDir_Nor", "IrrExtDif_Hor",
  "Elevation_Angle", "Azimuth_Angle", "TairExt", "pwPV" };

/* Function Declarations */
static void initialize_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance);
static void initialize_params_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance);
static void enable_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance);
static void disable_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance);
static void c5_update_debugger_state_c5_Zigor_Model
  (SFc5_Zigor_ModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c5_Zigor_Model
  (SFc5_Zigor_ModelInstanceStruct *chartInstance);
static void set_sim_state_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_st);
static void finalize_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance);
static void sf_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance);
static void initSimStructsc5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber);
static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData);
static real_T c5_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct *chartInstance,
  const mxArray *c5_P_Solar, const char_T *c5_identifier);
static real_T c5_b_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static c5_saSOdeh07LmZXv3qQ5udJsG c5_c_emlrt_marshallIn
  (SFc5_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c5_u, const
   emlrtMsgIdentifier *c5_parentId);
static c5_sCKvBU3U0z4KB0OM7v1DGpC c5_d_emlrt_marshallIn
  (SFc5_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c5_u, const
   emlrtMsgIdentifier *c5_parentId);
static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static void c5_info_helper(c5_ResolvedFunctionInfo c5_info[27]);
static real_T c5_PowSolar_PV(SFc5_Zigor_ModelInstanceStruct *chartInstance,
  c5_saSOdeh07LmZXv3qQ5udJsG c5_Param, real_T c5_IrrExtDir_Nor, real_T
  c5_IrrExtDif_Hor, real_T c5_Elevation_Angle, real_T c5_Azimuth_Angle, real_T
  c5_TairExt);
static real_T c5_degtorad(SFc5_Zigor_ModelInstanceStruct *chartInstance, real_T
  c5_angleInDegrees);
static void c5_eml_scalar_eg(SFc5_Zigor_ModelInstanceStruct *chartInstance);
static void c5_eml_error(SFc5_Zigor_ModelInstanceStruct *chartInstance);
static const mxArray *c5_d_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData);
static int32_T c5_e_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void c5_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData);
static uint8_T c5_f_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_b_is_active_c5_Zigor_Model, const char_T
  *c5_identifier);
static uint8_T c5_g_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId);
static void init_dsm_address_info(SFc5_Zigor_ModelInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance)
{
  chartInstance->c5_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c5_is_active_c5_Zigor_Model = 0U;
}

static void initialize_params_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance)
{
}

static void enable_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c5_update_debugger_state_c5_Zigor_Model
  (SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c5_Zigor_Model
  (SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
  const mxArray *c5_st;
  const mxArray *c5_y = NULL;
  real_T c5_hoistedGlobal;
  real_T c5_u;
  const mxArray *c5_b_y = NULL;
  uint8_T c5_b_hoistedGlobal;
  uint8_T c5_b_u;
  const mxArray *c5_c_y = NULL;
  real_T *c5_P_Solar;
  c5_P_Solar = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c5_st = NULL;
  c5_st = NULL;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_createcellarray(2), FALSE);
  c5_hoistedGlobal = *c5_P_Solar;
  c5_u = c5_hoistedGlobal;
  c5_b_y = NULL;
  sf_mex_assign(&c5_b_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 0, c5_b_y);
  c5_b_hoistedGlobal = chartInstance->c5_is_active_c5_Zigor_Model;
  c5_b_u = c5_b_hoistedGlobal;
  c5_c_y = NULL;
  sf_mex_assign(&c5_c_y, sf_mex_create("y", &c5_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c5_y, 1, c5_c_y);
  sf_mex_assign(&c5_st, c5_y, FALSE);
  return c5_st;
}

static void set_sim_state_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_st)
{
  const mxArray *c5_u;
  real_T *c5_P_Solar;
  c5_P_Solar = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c5_doneDoubleBufferReInit = TRUE;
  c5_u = sf_mex_dup(c5_st);
  *c5_P_Solar = c5_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c5_u, 0)), "P_Solar");
  chartInstance->c5_is_active_c5_Zigor_Model = c5_f_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c5_u, 1)),
     "is_active_c5_Zigor_Model");
  sf_mex_destroy(&c5_u);
  c5_update_debugger_state_c5_Zigor_Model(chartInstance);
  sf_mex_destroy(&c5_st);
}

static void finalize_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance)
{
}

static void sf_c5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
  int32_T c5_i0;
  int32_T c5_i1;
  real_T c5_u[12];
  uint32_T c5_debug_family_var_map[10];
  c5_saSOdeh07LmZXv3qQ5udJsG c5_Param;
  real_T c5_IrrDirect;
  real_T c5_IrrDiffuse;
  real_T c5_Elevation;
  real_T c5_Azimuth;
  real_T c5_Tair;
  real_T c5_nargin = 1.0;
  real_T c5_nargout = 1.0;
  real_T c5_P_Solar;
  real_T *c5_b_P_Solar;
  real_T (*c5_b_u)[12];
  c5_b_P_Solar = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c5_b_u = (real_T (*)[12])ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 1U, chartInstance->c5_sfEvent);
  for (c5_i0 = 0; c5_i0 < 12; c5_i0++) {
    _SFD_DATA_RANGE_CHECK((*c5_b_u)[c5_i0], 0U);
  }

  _SFD_DATA_RANGE_CHECK(*c5_b_P_Solar, 1U);
  chartInstance->c5_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 1U, chartInstance->c5_sfEvent);
  for (c5_i1 = 0; c5_i1 < 12; c5_i1++) {
    c5_u[c5_i1] = (*c5_b_u)[c5_i1];
  }

  sf_debug_symbol_scope_push_eml(0U, 10U, 10U, c5_debug_family_names,
    c5_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c5_Param, 0U, c5_c_sf_marshallOut,
    c5_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_IrrDirect, 1U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_IrrDiffuse, 2U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Elevation, 3U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Azimuth, 4U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Tair, 5U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargin, 6U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargout, 7U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml(c5_u, 8U, c5_b_sf_marshallOut);
  sf_debug_symbol_scope_add_eml_importable(&c5_P_Solar, 9U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 2);
  c5_Param.Orientation.tilt = c5_u[0];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 3);
  c5_Param.Orientation.SO = c5_u[1];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 4);
  c5_Param.insPwPV = c5_u[2];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 5);
  c5_Param.TempPcoeffPV = c5_u[3];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 6);
  c5_Param.NOCT = c5_u[4];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 7);
  c5_Param.Kl = c5_u[5];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 8);
  c5_Param.Albedo = c5_u[6];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 9);
  c5_IrrDirect = c5_u[7];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 10);
  c5_IrrDiffuse = c5_u[8];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 11);
  c5_Elevation = c5_u[9];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 12);
  c5_Azimuth = c5_u[10];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 13);
  c5_Tair = c5_u[11];
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, 15);
  c5_P_Solar = c5_PowSolar_PV(chartInstance, c5_Param, c5_IrrDirect,
    c5_IrrDiffuse, c5_Elevation, c5_Azimuth, c5_Tair);
  _SFD_EML_CALL(0U, chartInstance->c5_sfEvent, -15);
  sf_debug_symbol_scope_pop();
  *c5_b_P_Solar = c5_P_Solar;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c5_sfEvent);
  sf_debug_check_for_state_inconsistency(_Zigor_ModelMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc5_Zigor_Model(SFc5_Zigor_ModelInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c5_machineNumber, uint32_T
  c5_chartNumber)
{
  _SFD_SCRIPT_TRANSLATION(c5_chartNumber, 0U, sf_debug_get_script_id(
    "C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m"));
}

static const mxArray *c5_sf_marshallOut(void *chartInstanceVoid, void *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  real_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(real_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static real_T c5_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct *chartInstance,
  const mxArray *c5_P_Solar, const char_T *c5_identifier)
{
  real_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_P_Solar), &c5_thisId);
  sf_mex_destroy(&c5_P_Solar);
  return c5_y;
}

static real_T c5_b_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  real_T c5_y;
  real_T c5_d0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_d0, 1, 0, 0U, 0, 0U, 0);
  c5_y = c5_d0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_P_Solar;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  real_T c5_y;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_P_Solar = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_P_Solar), &c5_thisId);
  sf_mex_destroy(&c5_P_Solar);
  *(real_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static const mxArray *c5_b_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  int32_T c5_i2;
  real_T c5_b_inData[12];
  int32_T c5_i3;
  real_T c5_u[12];
  const mxArray *c5_y = NULL;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  for (c5_i2 = 0; c5_i2 < 12; c5_i2++) {
    c5_b_inData[c5_i2] = (*(real_T (*)[12])c5_inData)[c5_i2];
  }

  for (c5_i3 = 0; c5_i3 < 12; c5_i3++) {
    c5_u[c5_i3] = c5_b_inData[c5_i3];
  }

  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", c5_u, 0, 0U, 1U, 0U, 1, 12), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static const mxArray *c5_c_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData;
  c5_saSOdeh07LmZXv3qQ5udJsG c5_u;
  const mxArray *c5_y = NULL;
  c5_sCKvBU3U0z4KB0OM7v1DGpC c5_b_u;
  const mxArray *c5_b_y = NULL;
  real_T c5_c_u;
  const mxArray *c5_c_y = NULL;
  real_T c5_d_u;
  const mxArray *c5_d_y = NULL;
  real_T c5_e_u;
  const mxArray *c5_e_y = NULL;
  real_T c5_f_u;
  const mxArray *c5_f_y = NULL;
  real_T c5_g_u;
  const mxArray *c5_g_y = NULL;
  real_T c5_h_u;
  const mxArray *c5_h_y = NULL;
  real_T c5_i_u;
  const mxArray *c5_i_y = NULL;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_mxArrayOutData = NULL;
  c5_u = *(c5_saSOdeh07LmZXv3qQ5udJsG *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_createstruct("structure", 2, 1, 1), FALSE);
  c5_b_u = c5_u.Orientation;
  c5_b_y = NULL;
  sf_mex_assign(&c5_b_y, sf_mex_createstruct("structure", 2, 1, 1), FALSE);
  c5_c_u = c5_b_u.tilt;
  c5_c_y = NULL;
  sf_mex_assign(&c5_c_y, sf_mex_create("y", &c5_c_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_b_y, c5_c_y, "tilt", "tilt", 0);
  c5_d_u = c5_b_u.SO;
  c5_d_y = NULL;
  sf_mex_assign(&c5_d_y, sf_mex_create("y", &c5_d_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_b_y, c5_d_y, "SO", "SO", 0);
  sf_mex_addfield(c5_y, c5_b_y, "Orientation", "Orientation", 0);
  c5_e_u = c5_u.insPwPV;
  c5_e_y = NULL;
  sf_mex_assign(&c5_e_y, sf_mex_create("y", &c5_e_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_y, c5_e_y, "insPwPV", "insPwPV", 0);
  c5_f_u = c5_u.TempPcoeffPV;
  c5_f_y = NULL;
  sf_mex_assign(&c5_f_y, sf_mex_create("y", &c5_f_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_y, c5_f_y, "TempPcoeffPV", "TempPcoeffPV", 0);
  c5_g_u = c5_u.NOCT;
  c5_g_y = NULL;
  sf_mex_assign(&c5_g_y, sf_mex_create("y", &c5_g_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_y, c5_g_y, "NOCT", "NOCT", 0);
  c5_h_u = c5_u.Kl;
  c5_h_y = NULL;
  sf_mex_assign(&c5_h_y, sf_mex_create("y", &c5_h_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_y, c5_h_y, "Kl", "Kl", 0);
  c5_i_u = c5_u.Albedo;
  c5_i_y = NULL;
  sf_mex_assign(&c5_i_y, sf_mex_create("y", &c5_i_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_addfield(c5_y, c5_i_y, "Albedo", "Albedo", 0);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static c5_saSOdeh07LmZXv3qQ5udJsG c5_c_emlrt_marshallIn
  (SFc5_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c5_u, const
   emlrtMsgIdentifier *c5_parentId)
{
  c5_saSOdeh07LmZXv3qQ5udJsG c5_y;
  emlrtMsgIdentifier c5_thisId;
  static const char * c5_fieldNames[6] = { "Orientation", "insPwPV",
    "TempPcoeffPV", "NOCT", "Kl", "Albedo" };

  c5_thisId.fParent = c5_parentId;
  sf_mex_check_struct(c5_parentId, c5_u, 6, c5_fieldNames, 0U, 0);
  c5_thisId.fIdentifier = "Orientation";
  c5_y.Orientation = c5_d_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getfield(c5_u, "Orientation", "Orientation", 0)), &c5_thisId);
  c5_thisId.fIdentifier = "insPwPV";
  c5_y.insPwPV = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield
                                        (c5_u, "insPwPV", "insPwPV", 0)),
    &c5_thisId);
  c5_thisId.fIdentifier = "TempPcoeffPV";
  c5_y.TempPcoeffPV = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getfield(c5_u, "TempPcoeffPV", "TempPcoeffPV", 0)), &c5_thisId);
  c5_thisId.fIdentifier = "NOCT";
  c5_y.NOCT = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield
    (c5_u, "NOCT", "NOCT", 0)), &c5_thisId);
  c5_thisId.fIdentifier = "Kl";
  c5_y.Kl = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c5_u,
    "Kl", "Kl", 0)), &c5_thisId);
  c5_thisId.fIdentifier = "Albedo";
  c5_y.Albedo = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield
    (c5_u, "Albedo", "Albedo", 0)), &c5_thisId);
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static c5_sCKvBU3U0z4KB0OM7v1DGpC c5_d_emlrt_marshallIn
  (SFc5_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c5_u, const
   emlrtMsgIdentifier *c5_parentId)
{
  c5_sCKvBU3U0z4KB0OM7v1DGpC c5_y;
  emlrtMsgIdentifier c5_thisId;
  static const char * c5_fieldNames[2] = { "tilt", "SO" };

  c5_thisId.fParent = c5_parentId;
  sf_mex_check_struct(c5_parentId, c5_u, 2, c5_fieldNames, 0U, 0);
  c5_thisId.fIdentifier = "tilt";
  c5_y.tilt = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield
    (c5_u, "tilt", "tilt", 0)), &c5_thisId);
  c5_thisId.fIdentifier = "SO";
  c5_y.SO = c5_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c5_u,
    "SO", "SO", 0)), &c5_thisId);
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_Param;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  c5_saSOdeh07LmZXv3qQ5udJsG c5_y;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_Param = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_Param), &c5_thisId);
  sf_mex_destroy(&c5_Param);
  *(c5_saSOdeh07LmZXv3qQ5udJsG *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

const mxArray *sf_c5_Zigor_Model_get_eml_resolved_functions_info(void)
{
  const mxArray *c5_nameCaptureInfo;
  c5_ResolvedFunctionInfo c5_info[27];
  const mxArray *c5_m0 = NULL;
  int32_T c5_i4;
  c5_ResolvedFunctionInfo *c5_r0;
  c5_nameCaptureInfo = NULL;
  c5_nameCaptureInfo = NULL;
  c5_info_helper(c5_info);
  sf_mex_assign(&c5_m0, sf_mex_createstruct("nameCaptureInfo", 1, 27), FALSE);
  for (c5_i4 = 0; c5_i4 < 27; c5_i4++) {
    c5_r0 = &c5_info[c5_i4];
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c5_r0->context)), "context", "nameCaptureInfo",
                    c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c5_r0->name)), "name", "nameCaptureInfo", c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c5_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", c5_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c5_r0->resolved)), "resolved", "nameCaptureInfo",
                    c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c5_i4);
    sf_mex_addfield(c5_m0, sf_mex_create("nameCaptureInfo", &c5_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c5_i4);
  }

  sf_mex_assign(&c5_nameCaptureInfo, c5_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c5_nameCaptureInfo);
  return c5_nameCaptureInfo;
}

static void c5_info_helper(c5_ResolvedFunctionInfo c5_info[27])
{
  c5_info[0].context = "";
  c5_info[0].name = "PowSolar_PV";
  c5_info[0].dominantType = "struct";
  c5_info[0].resolved =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[0].fileTimeLo = 1431356682U;
  c5_info[0].fileTimeHi = 0U;
  c5_info[0].mFileTimeLo = 0U;
  c5_info[0].mFileTimeHi = 0U;
  c5_info[1].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[1].name = "disp";
  c5_info[1].dominantType = "char";
  c5_info[1].resolved = "[IXMB]$matlabroot$/toolbox/matlab/lang/disp";
  c5_info[1].fileTimeLo = MAX_uint32_T;
  c5_info[1].fileTimeHi = MAX_uint32_T;
  c5_info[1].mFileTimeLo = MAX_uint32_T;
  c5_info[1].mFileTimeHi = MAX_uint32_T;
  c5_info[2].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m!degtorad";
  c5_info[2].name = "mrdivide";
  c5_info[2].dominantType = "double";
  c5_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c5_info[2].fileTimeLo = 1342810944U;
  c5_info[2].fileTimeHi = 0U;
  c5_info[2].mFileTimeLo = 1319729966U;
  c5_info[2].mFileTimeHi = 0U;
  c5_info[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c5_info[3].name = "rdivide";
  c5_info[3].dominantType = "double";
  c5_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c5_info[3].fileTimeLo = 1286818844U;
  c5_info[3].fileTimeHi = 0U;
  c5_info[3].mFileTimeLo = 0U;
  c5_info[3].mFileTimeHi = 0U;
  c5_info[4].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c5_info[4].name = "eml_div";
  c5_info[4].dominantType = "double";
  c5_info[4].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c5_info[4].fileTimeLo = 1313347810U;
  c5_info[4].fileTimeHi = 0U;
  c5_info[4].mFileTimeLo = 0U;
  c5_info[4].mFileTimeHi = 0U;
  c5_info[5].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m!degtorad";
  c5_info[5].name = "mtimes";
  c5_info[5].dominantType = "double";
  c5_info[5].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c5_info[5].fileTimeLo = 1289519692U;
  c5_info[5].fileTimeHi = 0U;
  c5_info[5].mFileTimeLo = 0U;
  c5_info[5].mFileTimeHi = 0U;
  c5_info[6].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[6].name = "sin";
  c5_info[6].dominantType = "double";
  c5_info[6].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sin.m";
  c5_info[6].fileTimeLo = 1286818750U;
  c5_info[6].fileTimeHi = 0U;
  c5_info[6].mFileTimeLo = 0U;
  c5_info[6].mFileTimeHi = 0U;
  c5_info[7].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sin.m";
  c5_info[7].name = "eml_scalar_sin";
  c5_info[7].dominantType = "double";
  c5_info[7].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_sin.m";
  c5_info[7].fileTimeLo = 1286818736U;
  c5_info[7].fileTimeHi = 0U;
  c5_info[7].mFileTimeLo = 0U;
  c5_info[7].mFileTimeHi = 0U;
  c5_info[8].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[8].name = "cos";
  c5_info[8].dominantType = "double";
  c5_info[8].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/cos.m";
  c5_info[8].fileTimeLo = 1286818706U;
  c5_info[8].fileTimeHi = 0U;
  c5_info[8].mFileTimeLo = 0U;
  c5_info[8].mFileTimeHi = 0U;
  c5_info[9].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/cos.m";
  c5_info[9].name = "eml_scalar_cos";
  c5_info[9].dominantType = "double";
  c5_info[9].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_cos.m";
  c5_info[9].fileTimeLo = 1286818722U;
  c5_info[9].fileTimeHi = 0U;
  c5_info[9].mFileTimeLo = 0U;
  c5_info[9].mFileTimeHi = 0U;
  c5_info[10].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[10].name = "mtimes";
  c5_info[10].dominantType = "double";
  c5_info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c5_info[10].fileTimeLo = 1289519692U;
  c5_info[10].fileTimeHi = 0U;
  c5_info[10].mFileTimeLo = 0U;
  c5_info[10].mFileTimeHi = 0U;
  c5_info[11].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[11].name = "max";
  c5_info[11].dominantType = "double";
  c5_info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c5_info[11].fileTimeLo = 1311255316U;
  c5_info[11].fileTimeHi = 0U;
  c5_info[11].mFileTimeLo = 0U;
  c5_info[11].mFileTimeHi = 0U;
  c5_info[12].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c5_info[12].name = "eml_min_or_max";
  c5_info[12].dominantType = "char";
  c5_info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c5_info[12].fileTimeLo = 1334071490U;
  c5_info[12].fileTimeHi = 0U;
  c5_info[12].mFileTimeLo = 0U;
  c5_info[12].mFileTimeHi = 0U;
  c5_info[13].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
  c5_info[13].name = "eml_scalar_eg";
  c5_info[13].dominantType = "double";
  c5_info[13].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c5_info[13].fileTimeLo = 1286818796U;
  c5_info[13].fileTimeHi = 0U;
  c5_info[13].mFileTimeLo = 0U;
  c5_info[13].mFileTimeHi = 0U;
  c5_info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
  c5_info[14].name = "eml_scalexp_alloc";
  c5_info[14].dominantType = "double";
  c5_info[14].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c5_info[14].fileTimeLo = 1330608434U;
  c5_info[14].fileTimeHi = 0U;
  c5_info[14].mFileTimeLo = 0U;
  c5_info[14].mFileTimeHi = 0U;
  c5_info[15].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
  c5_info[15].name = "eml_index_class";
  c5_info[15].dominantType = "";
  c5_info[15].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c5_info[15].fileTimeLo = 1323170578U;
  c5_info[15].fileTimeHi = 0U;
  c5_info[15].mFileTimeLo = 0U;
  c5_info[15].mFileTimeHi = 0U;
  c5_info[16].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_scalar_bin_extremum";
  c5_info[16].name = "eml_scalar_eg";
  c5_info[16].dominantType = "double";
  c5_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c5_info[16].fileTimeLo = 1286818796U;
  c5_info[16].fileTimeHi = 0U;
  c5_info[16].mFileTimeLo = 0U;
  c5_info[16].mFileTimeHi = 0U;
  c5_info[17].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[17].name = "mrdivide";
  c5_info[17].dominantType = "double";
  c5_info[17].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c5_info[17].fileTimeLo = 1342810944U;
  c5_info[17].fileTimeHi = 0U;
  c5_info[17].mFileTimeLo = 1319729966U;
  c5_info[17].mFileTimeHi = 0U;
  c5_info[18].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[18].name = "sqrt";
  c5_info[18].dominantType = "double";
  c5_info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c5_info[18].fileTimeLo = 1286818752U;
  c5_info[18].fileTimeHi = 0U;
  c5_info[18].mFileTimeLo = 0U;
  c5_info[18].mFileTimeHi = 0U;
  c5_info[19].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c5_info[19].name = "eml_error";
  c5_info[19].dominantType = "char";
  c5_info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  c5_info[19].fileTimeLo = 1305318000U;
  c5_info[19].fileTimeHi = 0U;
  c5_info[19].mFileTimeLo = 0U;
  c5_info[19].mFileTimeHi = 0U;
  c5_info[20].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c5_info[20].name = "eml_scalar_sqrt";
  c5_info[20].dominantType = "double";
  c5_info[20].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_sqrt.m";
  c5_info[20].fileTimeLo = 1286818738U;
  c5_info[20].fileTimeHi = 0U;
  c5_info[20].mFileTimeLo = 0U;
  c5_info[20].mFileTimeHi = 0U;
  c5_info[21].context =
    "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowSolar_PV.m";
  c5_info[21].name = "mpower";
  c5_info[21].dominantType = "double";
  c5_info[21].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c5_info[21].fileTimeLo = 1286818842U;
  c5_info[21].fileTimeHi = 0U;
  c5_info[21].mFileTimeLo = 0U;
  c5_info[21].mFileTimeHi = 0U;
  c5_info[22].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c5_info[22].name = "power";
  c5_info[22].dominantType = "double";
  c5_info[22].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c5_info[22].fileTimeLo = 1336522096U;
  c5_info[22].fileTimeHi = 0U;
  c5_info[22].mFileTimeLo = 0U;
  c5_info[22].mFileTimeHi = 0U;
  c5_info[23].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c5_info[23].name = "eml_scalar_eg";
  c5_info[23].dominantType = "double";
  c5_info[23].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c5_info[23].fileTimeLo = 1286818796U;
  c5_info[23].fileTimeHi = 0U;
  c5_info[23].mFileTimeLo = 0U;
  c5_info[23].mFileTimeHi = 0U;
  c5_info[24].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c5_info[24].name = "eml_scalexp_alloc";
  c5_info[24].dominantType = "double";
  c5_info[24].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c5_info[24].fileTimeLo = 1330608434U;
  c5_info[24].fileTimeHi = 0U;
  c5_info[24].mFileTimeLo = 0U;
  c5_info[24].mFileTimeHi = 0U;
  c5_info[25].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c5_info[25].name = "floor";
  c5_info[25].dominantType = "double";
  c5_info[25].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c5_info[25].fileTimeLo = 1286818742U;
  c5_info[25].fileTimeHi = 0U;
  c5_info[25].mFileTimeLo = 0U;
  c5_info[25].mFileTimeHi = 0U;
  c5_info[26].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c5_info[26].name = "eml_scalar_floor";
  c5_info[26].dominantType = "double";
  c5_info[26].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c5_info[26].fileTimeLo = 1286818726U;
  c5_info[26].fileTimeHi = 0U;
  c5_info[26].mFileTimeLo = 0U;
  c5_info[26].mFileTimeHi = 0U;
}

static real_T c5_PowSolar_PV(SFc5_Zigor_ModelInstanceStruct *chartInstance,
  c5_saSOdeh07LmZXv3qQ5udJsG c5_Param, real_T c5_IrrExtDir_Nor, real_T
  c5_IrrExtDif_Hor, real_T c5_Elevation_Angle, real_T c5_Azimuth_Angle, real_T
  c5_TairExt)
{
  real_T c5_pwPV;
  uint32_T c5_debug_family_var_map[14];
  real_T c5_FA;
  real_T c5_Ai;
  real_T c5_FAd;
  real_T c5_FAr;
  real_T c5_Tcell;
  real_T c5_nargin = 6.0;
  real_T c5_nargout = 1.0;
  int32_T c5_i5;
  static char_T c5_cv0[15] = { 'K', 'a', 'i', 'x', 'o', ' ', 'K', 'a', 'r', 'a',
    'p', 'a', 'i', 'x', 'o' };

  char_T c5_u[15];
  const mxArray *c5_y = NULL;
  real_T c5_x;
  real_T c5_b_x;
  real_T c5_c_x;
  real_T c5_d_x;
  real_T c5_a;
  real_T c5_b;
  real_T c5_b_y;
  real_T c5_e_x;
  real_T c5_f_x;
  real_T c5_g_x;
  real_T c5_h_x;
  real_T c5_b_a;
  real_T c5_b_b;
  real_T c5_c_y;
  real_T c5_i_x;
  real_T c5_j_x;
  real_T c5_c_a;
  real_T c5_c_b;
  real_T c5_d_y;
  real_T c5_varargin_1;
  real_T c5_varargin_2;
  real_T c5_k_x;
  real_T c5_l_x;
  real_T c5_xk;
  real_T c5_m_x;
  real_T c5_A;
  real_T c5_n_x;
  real_T c5_o_x;
  int32_T c5_i6;
  static char_T c5_cv1[16] = { 'K', 'a', 'i', 'x', 'o', ' ', 'K', 'a', 'r', 'a',
    'p', 'a', 'i', 'x', 'o', '1' };

  char_T c5_b_u[16];
  const mxArray *c5_e_y = NULL;
  real_T c5_d_a;
  real_T c5_d_b;
  real_T c5_f_y;
  real_T c5_p_x;
  real_T c5_q_x;
  real_T c5_e_a;
  real_T c5_e_b;
  real_T c5_g_y;
  real_T c5_b_A;
  real_T c5_r_x;
  real_T c5_s_x;
  real_T c5_h_y;
  real_T c5_t_x;
  real_T c5_u_x;
  real_T c5_f_a;
  real_T c5_f_b;
  real_T c5_i_y;
  real_T c5_v_x;
  real_T c5_w_x;
  real_T c5_g_a;
  real_T c5_g_b;
  real_T c5_j_y;
  real_T c5_c_A;
  real_T c5_B;
  real_T c5_x_x;
  real_T c5_k_y;
  real_T c5_y_x;
  real_T c5_l_y;
  real_T c5_m_y;
  real_T c5_ab_x;
  real_T c5_bb_x;
  real_T c5_d_A;
  real_T c5_cb_x;
  real_T c5_db_x;
  real_T c5_n_y;
  real_T c5_eb_x;
  real_T c5_fb_x;
  real_T c5_h_a;
  real_T c5_i_a;
  real_T c5_j_a;
  real_T c5_ak;
  real_T c5_c;
  real_T c5_k_a;
  real_T c5_h_b;
  real_T c5_o_y;
  real_T c5_l_a;
  real_T c5_i_b;
  real_T c5_p_y;
  real_T c5_b_varargin_1;
  real_T c5_b_varargin_2;
  real_T c5_gb_x;
  real_T c5_hb_x;
  real_T c5_b_xk;
  real_T c5_ib_x;
  int32_T c5_i7;
  static char_T c5_cv2[21] = { 'K', 'a', 'i', 'x', 'o', ' ', 'e', 't', 'a', ' ',
    'A', 'g', 'u', 'r', ' ', 'B', 'e', 'n', 'h', 'u', 'r' };

  char_T c5_c_u[21];
  const mxArray *c5_q_y = NULL;
  real_T c5_jb_x;
  real_T c5_kb_x;
  real_T c5_m_a;
  real_T c5_j_b;
  real_T c5_r_y;
  real_T c5_e_A;
  real_T c5_lb_x;
  real_T c5_mb_x;
  real_T c5_s_y;
  real_T c5_c_varargin_1;
  real_T c5_c_varargin_2;
  real_T c5_nb_x;
  real_T c5_ob_x;
  real_T c5_c_xk;
  real_T c5_pb_x;
  real_T c5_f_A;
  real_T c5_qb_x;
  real_T c5_rb_x;
  real_T c5_t_y;
  real_T c5_n_a;
  real_T c5_k_b;
  real_T c5_u_y;
  real_T c5_o_a;
  real_T c5_l_b;
  real_T c5_v_y;
  real_T c5_p_a;
  real_T c5_m_b;
  real_T c5_w_y;
  real_T c5_sb_x;
  real_T c5_tb_x;
  real_T c5_q_a;
  real_T c5_n_b;
  real_T c5_x_y;
  real_T c5_r_a;
  real_T c5_o_b;
  real_T c5_y_y;
  real_T c5_s_a;
  real_T c5_p_b;
  real_T c5_ab_y;
  real_T c5_g_A;
  real_T c5_ub_x;
  real_T c5_vb_x;
  real_T c5_bb_y;
  real_T c5_t_a;
  real_T c5_q_b;
  real_T c5_cb_y;
  real_T c5_h_A;
  real_T c5_wb_x;
  real_T c5_xb_x;
  real_T c5_db_y;
  real_T c5_u_a;
  real_T c5_r_b;
  real_T c5_eb_y;
  real_T c5_v_a;
  real_T c5_s_b;
  sf_debug_symbol_scope_push_eml(0U, 14U, 14U, c5_c_debug_family_names,
    c5_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c5_FA, 0U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Ai, 1U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_FAd, 2U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_FAr, 3U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Tcell, 4U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargin, 5U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargout, 6U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Param, 7U, c5_c_sf_marshallOut,
    c5_b_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_IrrExtDir_Nor, 8U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_IrrExtDif_Hor, 9U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Elevation_Angle, 10U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_Azimuth_Angle, 11U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_TairExt, 12U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_pwPV, 13U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  CV_SCRIPT_FCN(0, 0);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 144U);
  for (c5_i5 = 0; c5_i5 < 15; c5_i5++) {
    c5_u[c5_i5] = c5_cv0[c5_i5];
  }

  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", c5_u, 10, 0U, 1U, 0U, 2, 1, 15), FALSE);
  sf_mex_call_debug("disp", 0U, 1U, 14, c5_y);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 151U);
  c5_FA = 1.0;
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 167U);
  c5_x = c5_degtorad(chartInstance, c5_Elevation_Angle);
  c5_b_x = c5_x;
  c5_b_x = muDoubleScalarSin(c5_b_x);
  c5_c_x = c5_degtorad(chartInstance, c5_Param.Orientation.tilt);
  c5_d_x = c5_c_x;
  c5_d_x = muDoubleScalarCos(c5_d_x);
  c5_a = c5_b_x;
  c5_b = c5_d_x;
  c5_b_y = c5_a * c5_b;
  c5_e_x = c5_degtorad(chartInstance, c5_Elevation_Angle);
  c5_f_x = c5_e_x;
  c5_f_x = muDoubleScalarCos(c5_f_x);
  c5_g_x = c5_degtorad(chartInstance, c5_Param.Orientation.tilt);
  c5_h_x = c5_g_x;
  c5_h_x = muDoubleScalarSin(c5_h_x);
  c5_b_a = c5_f_x;
  c5_b_b = c5_h_x;
  c5_c_y = c5_b_a * c5_b_b;
  c5_i_x = c5_degtorad(chartInstance, c5_Azimuth_Angle - c5_Param.Orientation.SO);
  c5_j_x = c5_i_x;
  c5_j_x = muDoubleScalarCos(c5_j_x);
  c5_c_a = c5_c_y;
  c5_c_b = c5_j_x;
  c5_d_y = c5_c_a * c5_c_b;
  c5_varargin_1 = c5_b_y + c5_d_y;
  c5_varargin_2 = c5_varargin_1;
  c5_k_x = c5_varargin_2;
  c5_l_x = c5_k_x;
  c5_eml_scalar_eg(chartInstance);
  c5_xk = c5_l_x;
  c5_m_x = c5_xk;
  c5_eml_scalar_eg(chartInstance);
  c5_FA = muDoubleScalarMax(c5_m_x, 0.0);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 172U);
  c5_A = c5_IrrExtDir_Nor;
  c5_n_x = c5_A;
  c5_o_x = c5_n_x;
  c5_Ai = c5_o_x / 1367.0;
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 173U);
  for (c5_i6 = 0; c5_i6 < 16; c5_i6++) {
    c5_b_u[c5_i6] = c5_cv1[c5_i6];
  }

  c5_e_y = NULL;
  sf_mex_assign(&c5_e_y, sf_mex_create("y", c5_b_u, 10, 0U, 1U, 0U, 2, 1, 16),
                FALSE);
  sf_mex_call_debug("disp", 0U, 1U, 14, c5_e_y);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 174U);
  c5_d_a = c5_Ai;
  c5_d_b = c5_FA;
  c5_f_y = c5_d_a * c5_d_b;
  c5_p_x = c5_degtorad(chartInstance, c5_Param.Orientation.tilt);
  c5_q_x = c5_p_x;
  c5_q_x = muDoubleScalarCos(c5_q_x);
  c5_e_a = 1.0 - c5_Ai;
  c5_e_b = 1.0 + c5_q_x;
  c5_g_y = c5_e_a * c5_e_b;
  c5_b_A = c5_g_y;
  c5_r_x = c5_b_A;
  c5_s_x = c5_r_x;
  c5_h_y = c5_s_x / 2.0;
  c5_t_x = c5_degtorad(chartInstance, c5_Elevation_Angle);
  c5_u_x = c5_t_x;
  c5_u_x = muDoubleScalarSin(c5_u_x);
  c5_f_a = c5_IrrExtDir_Nor;
  c5_f_b = c5_u_x;
  c5_i_y = c5_f_a * c5_f_b;
  c5_v_x = c5_degtorad(chartInstance, c5_Elevation_Angle);
  c5_w_x = c5_v_x;
  c5_w_x = muDoubleScalarSin(c5_w_x);
  c5_g_a = c5_IrrExtDir_Nor;
  c5_g_b = c5_w_x;
  c5_j_y = c5_g_a * c5_g_b;
  c5_c_A = c5_i_y;
  c5_B = c5_IrrExtDif_Hor + c5_j_y;
  c5_x_x = c5_c_A;
  c5_k_y = c5_B;
  c5_y_x = c5_x_x;
  c5_l_y = c5_k_y;
  c5_m_y = c5_y_x / c5_l_y;
  c5_ab_x = c5_m_y;
  c5_bb_x = c5_ab_x;
  if (c5_bb_x < 0.0) {
    c5_eml_error(chartInstance);
  }

  c5_bb_x = muDoubleScalarSqrt(c5_bb_x);
  c5_d_A = c5_Param.Orientation.tilt;
  c5_cb_x = c5_d_A;
  c5_db_x = c5_cb_x;
  c5_n_y = c5_db_x / 2.0;
  c5_eb_x = c5_degtorad(chartInstance, c5_n_y);
  c5_fb_x = c5_eb_x;
  c5_fb_x = muDoubleScalarSin(c5_fb_x);
  c5_h_a = c5_fb_x;
  c5_i_a = c5_h_a;
  c5_j_a = c5_i_a;
  c5_eml_scalar_eg(chartInstance);
  c5_ak = c5_j_a;
  c5_c = muDoubleScalarPower(c5_ak, 3.0);
  c5_k_a = c5_bb_x;
  c5_h_b = c5_c;
  c5_o_y = c5_k_a * c5_h_b;
  c5_l_a = c5_h_y;
  c5_i_b = 1.0 + c5_o_y;
  c5_p_y = c5_l_a * c5_i_b;
  c5_b_varargin_1 = c5_f_y + c5_p_y;
  c5_b_varargin_2 = c5_b_varargin_1;
  c5_gb_x = c5_b_varargin_2;
  c5_hb_x = c5_gb_x;
  c5_eml_scalar_eg(chartInstance);
  c5_b_xk = c5_hb_x;
  c5_ib_x = c5_b_xk;
  c5_eml_scalar_eg(chartInstance);
  c5_FAd = muDoubleScalarMax(c5_ib_x, 0.0);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 178U);
  for (c5_i7 = 0; c5_i7 < 21; c5_i7++) {
    c5_c_u[c5_i7] = c5_cv2[c5_i7];
  }

  c5_q_y = NULL;
  sf_mex_assign(&c5_q_y, sf_mex_create("y", c5_c_u, 10, 0U, 1U, 0U, 2, 1, 21),
                FALSE);
  sf_mex_call_debug("disp", 0U, 1U, 14, c5_q_y);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 180U);
  c5_jb_x = c5_degtorad(chartInstance, c5_Param.Orientation.tilt);
  c5_kb_x = c5_jb_x;
  c5_kb_x = muDoubleScalarCos(c5_kb_x);
  c5_m_a = c5_Param.Albedo;
  c5_j_b = 1.0 - c5_kb_x;
  c5_r_y = c5_m_a * c5_j_b;
  c5_e_A = c5_r_y;
  c5_lb_x = c5_e_A;
  c5_mb_x = c5_lb_x;
  c5_s_y = c5_mb_x / 2.0;
  c5_c_varargin_1 = c5_s_y;
  c5_c_varargin_2 = c5_c_varargin_1;
  c5_nb_x = c5_c_varargin_2;
  c5_ob_x = c5_nb_x;
  c5_eml_scalar_eg(chartInstance);
  c5_c_xk = c5_ob_x;
  c5_pb_x = c5_c_xk;
  c5_eml_scalar_eg(chartInstance);
  c5_FAr = muDoubleScalarMax(c5_pb_x, 0.0);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 185U);
  c5_f_A = c5_Param.NOCT - 20.0;
  c5_qb_x = c5_f_A;
  c5_rb_x = c5_qb_x;
  c5_t_y = c5_rb_x / 800.0;
  c5_n_a = c5_t_y;
  c5_k_b = c5_IrrExtDir_Nor;
  c5_u_y = c5_n_a * c5_k_b;
  c5_Tcell = c5_TairExt + c5_u_y;
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 189U);
  c5_o_a = c5_IrrExtDir_Nor;
  c5_l_b = c5_FA;
  c5_v_y = c5_o_a * c5_l_b;
  c5_p_a = c5_IrrExtDif_Hor;
  c5_m_b = c5_FAd;
  c5_w_y = c5_p_a * c5_m_b;
  c5_sb_x = c5_degtorad(chartInstance, c5_Elevation_Angle);
  c5_tb_x = c5_sb_x;
  c5_tb_x = muDoubleScalarSin(c5_tb_x);
  c5_q_a = c5_IrrExtDir_Nor;
  c5_n_b = c5_tb_x;
  c5_x_y = c5_q_a * c5_n_b;
  c5_r_a = c5_IrrExtDif_Hor + c5_x_y;
  c5_o_b = c5_FAr;
  c5_y_y = c5_r_a * c5_o_b;
  c5_s_a = c5_Param.Kl;
  c5_p_b = (c5_v_y + c5_w_y) + c5_y_y;
  c5_ab_y = c5_s_a * c5_p_b;
  c5_g_A = c5_ab_y;
  c5_ub_x = c5_g_A;
  c5_vb_x = c5_ub_x;
  c5_bb_y = c5_vb_x / 1000.0;
  c5_t_a = c5_bb_y;
  c5_q_b = c5_Param.insPwPV;
  c5_cb_y = c5_t_a * c5_q_b;
  c5_h_A = c5_Param.TempPcoeffPV;
  c5_wb_x = c5_h_A;
  c5_xb_x = c5_wb_x;
  c5_db_y = c5_xb_x / 100.0;
  c5_u_a = c5_db_y;
  c5_r_b = c5_Tcell - 25.0;
  c5_eb_y = c5_u_a * c5_r_b;
  c5_v_a = c5_cb_y;
  c5_s_b = 1.0 + c5_eb_y;
  c5_pwPV = c5_v_a * c5_s_b;
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, -189);
  sf_debug_symbol_scope_pop();
  return c5_pwPV;
}

static real_T c5_degtorad(SFc5_Zigor_ModelInstanceStruct *chartInstance, real_T
  c5_angleInDegrees)
{
  real_T c5_angleInRadians;
  uint32_T c5_debug_family_var_map[4];
  real_T c5_nargin = 1.0;
  real_T c5_nargout = 1.0;
  real_T c5_b;
  sf_debug_symbol_scope_push_eml(0U, 4U, 4U, c5_b_debug_family_names,
    c5_debug_family_var_map);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargin, 0U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_nargout, 1U, c5_sf_marshallOut,
    c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_angleInDegrees, 2U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  sf_debug_symbol_scope_add_eml_importable(&c5_angleInRadians, 3U,
    c5_sf_marshallOut, c5_sf_marshallIn);
  CV_SCRIPT_FCN(0, 1);
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, 217U);
  c5_b = c5_angleInDegrees;
  c5_angleInRadians = 0.017453292519943295 * c5_b;
  _SFD_SCRIPT_CALL(0U, chartInstance->c5_sfEvent, -217);
  sf_debug_symbol_scope_pop();
  return c5_angleInRadians;
}

static void c5_eml_scalar_eg(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
}

static void c5_eml_error(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
  int32_T c5_i8;
  static char_T c5_varargin_1[30] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o',
    'o', 'l', 'b', 'o', 'x', ':', 's', 'q', 'r', 't', '_', 'd', 'o', 'm', 'a',
    'i', 'n', 'E', 'r', 'r', 'o', 'r' };

  char_T c5_u[30];
  const mxArray *c5_y = NULL;
  for (c5_i8 = 0; c5_i8 < 30; c5_i8++) {
    c5_u[c5_i8] = c5_varargin_1[c5_i8];
  }

  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", c5_u, 10, 0U, 1U, 0U, 2, 1, 30), FALSE);
  sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 1U, 14,
    c5_y));
}

static const mxArray *c5_d_sf_marshallOut(void *chartInstanceVoid, void
  *c5_inData)
{
  const mxArray *c5_mxArrayOutData = NULL;
  int32_T c5_u;
  const mxArray *c5_y = NULL;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_mxArrayOutData = NULL;
  c5_u = *(int32_T *)c5_inData;
  c5_y = NULL;
  sf_mex_assign(&c5_y, sf_mex_create("y", &c5_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c5_mxArrayOutData, c5_y, FALSE);
  return c5_mxArrayOutData;
}

static int32_T c5_e_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  int32_T c5_y;
  int32_T c5_i9;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_i9, 1, 6, 0U, 0, 0U, 0);
  c5_y = c5_i9;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void c5_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c5_mxArrayInData, const char_T *c5_varName, void *c5_outData)
{
  const mxArray *c5_b_sfEvent;
  const char_T *c5_identifier;
  emlrtMsgIdentifier c5_thisId;
  int32_T c5_y;
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)chartInstanceVoid;
  c5_b_sfEvent = sf_mex_dup(c5_mxArrayInData);
  c5_identifier = c5_varName;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c5_b_sfEvent),
    &c5_thisId);
  sf_mex_destroy(&c5_b_sfEvent);
  *(int32_T *)c5_outData = c5_y;
  sf_mex_destroy(&c5_mxArrayInData);
}

static uint8_T c5_f_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_b_is_active_c5_Zigor_Model, const char_T
  *c5_identifier)
{
  uint8_T c5_y;
  emlrtMsgIdentifier c5_thisId;
  c5_thisId.fIdentifier = c5_identifier;
  c5_thisId.fParent = NULL;
  c5_y = c5_g_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c5_b_is_active_c5_Zigor_Model), &c5_thisId);
  sf_mex_destroy(&c5_b_is_active_c5_Zigor_Model);
  return c5_y;
}

static uint8_T c5_g_emlrt_marshallIn(SFc5_Zigor_ModelInstanceStruct
  *chartInstance, const mxArray *c5_u, const emlrtMsgIdentifier *c5_parentId)
{
  uint8_T c5_y;
  uint8_T c5_u0;
  sf_mex_import(c5_parentId, sf_mex_dup(c5_u), &c5_u0, 1, 3, 0U, 0, 0U, 0);
  c5_y = c5_u0;
  sf_mex_destroy(&c5_u);
  return c5_y;
}

static void init_dsm_address_info(SFc5_Zigor_ModelInstanceStruct *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c5_Zigor_Model_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(999081079U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(866282382U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2350869984U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1450839761U);
}

mxArray *sf_c5_Zigor_Model_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("AZJTMZSvxpPD8UhYWjRm1F");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(12);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

static const mxArray *sf_get_sim_state_info_c5_Zigor_Model(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"P_Solar\",},{M[8],M[0],T\"is_active_c5_Zigor_Model\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c5_Zigor_Model_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc5_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc5_Zigor_ModelInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (_Zigor_ModelMachineNumber_,
           5,
           1,
           1,
           2,
           0,
           0,
           0,
           0,
           1,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_Zigor_ModelMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting(_Zigor_ModelMachineNumber_,
            chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(_Zigor_ModelMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"u");
          _SFD_SET_DATA_PROPS(1,2,0,1,"P_Solar");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,367);
        _SFD_CV_INIT_SCRIPT(0,2,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_SCRIPT_FCN(0,0,"PowSolar_PV",7425,-1,9668);
        _SFD_CV_INIT_SCRIPT_FCN(0,1,"degtorad",9720,-1,10227);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        {
          unsigned int dimVector[1];
          dimVector[0]= 12;
          _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,1,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c5_b_sf_marshallOut,(MexInFcnForType)NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c5_sf_marshallOut,(MexInFcnForType)c5_sf_marshallIn);

        {
          real_T *c5_P_Solar;
          real_T (*c5_u)[12];
          c5_P_Solar = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c5_u = (real_T (*)[12])ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, *c5_u);
          _SFD_SET_DATA_VALUE_PTR(1U, c5_P_Solar);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(_Zigor_ModelMachineNumber_,
        chartInstance->chartNumber,chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization()
{
  return "BT217wIQUpnkWmF0rhCqnE";
}

static void sf_opaque_initialize_c5_Zigor_Model(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar)
    ->S,0);
  initialize_params_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*)
    chartInstanceVar);
  initialize_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c5_Zigor_Model(void *chartInstanceVar)
{
  enable_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c5_Zigor_Model(void *chartInstanceVar)
{
  disable_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c5_Zigor_Model(void *chartInstanceVar)
{
  sf_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c5_Zigor_Model(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c5_Zigor_Model
    ((SFc5_Zigor_ModelInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_Zigor_Model();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c5_Zigor_Model(SimStruct* S, const mxArray
  *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c5_Zigor_Model();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c5_Zigor_Model(SimStruct* S)
{
  return sf_internal_get_sim_state_c5_Zigor_Model(S);
}

static void sf_opaque_set_sim_state_c5_Zigor_Model(SimStruct* S, const mxArray
  *st)
{
  sf_internal_set_sim_state_c5_Zigor_Model(S, st);
}

static void sf_opaque_terminate_c5_Zigor_Model(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*) chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }

  unload_Zigor_Model_optimization_info();
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c5_Zigor_Model(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c5_Zigor_Model((SFc5_Zigor_ModelInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c5_Zigor_Model(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_Zigor_Model_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      5);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,5,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,5,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,5,1);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,5,1);
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,5);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(2305059606U));
  ssSetChecksum1(S,(504961381U));
  ssSetChecksum2(S,(3745436196U));
  ssSetChecksum3(S,(3728485504U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c5_Zigor_Model(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c5_Zigor_Model(SimStruct *S)
{
  SFc5_Zigor_ModelInstanceStruct *chartInstance;
  chartInstance = (SFc5_Zigor_ModelInstanceStruct *)malloc(sizeof
    (SFc5_Zigor_ModelInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc5_Zigor_ModelInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c5_Zigor_Model;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c5_Zigor_Model;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c5_Zigor_Model;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c5_Zigor_Model;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c5_Zigor_Model;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c5_Zigor_Model;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c5_Zigor_Model;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c5_Zigor_Model;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c5_Zigor_Model;
  chartInstance->chartInfo.mdlStart = mdlStart_c5_Zigor_Model;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c5_Zigor_Model;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c5_Zigor_Model_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c5_Zigor_Model(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c5_Zigor_Model(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c5_Zigor_Model(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c5_Zigor_Model_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
