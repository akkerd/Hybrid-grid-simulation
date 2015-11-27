/* Include files */
#include "blascompat32.h"
#include "Zigor_Model_sfun.h"
#include "c4_Zigor_Model.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER (chartInstance->instanceNumber)
#include "Zigor_Model_sfun_debug_macros.h"

/* Type Definitions */

















































/* Named Constants */
#define CALL_EVENT (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c4_debug_family_names[8] = { "Param", "PowSolar_PV", "PV_Ctl", "PV_Shaving_Ctl", "nargin", "nargout", "u", "P_Elec" };

/* Function Declarations */
static void initialize_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void initialize_params_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void enable_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void disable_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void c4_update_debugger_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void set_sim_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_st);
static void finalize_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void sf_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void c4_chartstep_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void initSimStructsc4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c4_machineNumber, uint32_T c4_chartNumber);
static const mxArray *c4_sf_marshallOut(void *chartInstanceVoid, void *c4_inData);
static real_T c4_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_P_Elec, const char_T *c4_identifier);
static real_T c4_b_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static const mxArray *c4_b_sf_marshallOut(void *chartInstanceVoid, void *c4_inData);
static const mxArray *c4_c_sf_marshallOut(void *chartInstanceVoid, void *c4_inData);
static c4_sao7lvpULMJbzgO3vhk2pkD c4_c_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId);
static c4_szlnHL9Df6pKpDV9xqQkSJG c4_d_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_b_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static void c4_info_helper(c4_ResolvedFunctionInfo c4_info[17]);
static real_T c4_mpower(SFc4_Zigor_ModelInstanceStruct *chartInstance, real_T c4_a);
static void c4_eml_scalar_eg(SFc4_Zigor_ModelInstanceStruct *chartInstance);
static const mxArray *c4_d_sf_marshallOut(void *chartInstanceVoid, void *c4_inData);
static int32_T c4_e_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_c_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static uint8_T c4_f_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_b_is_active_c4_Zigor_Model, const char_T *c4_identifier);
static uint8_T c4_g_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void init_dsm_address_info(SFc4_Zigor_ModelInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    chartInstance->c4_sfEvent = CALL_EVENT;
    _sfTime_ = (real_T)ssGetT(chartInstance->S);
    chartInstance->c4_is_active_c4_Zigor_Model = 0U;
}

static void initialize_params_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

static void enable_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c4_update_debugger_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    const mxArray *c4_st;
    const mxArray *c4_y = NULL;
    real_T c4_hoistedGlobal;
    real_T c4_u;
    const mxArray *c4_b_y = NULL;
    uint8_T c4_b_hoistedGlobal;
    uint8_T c4_b_u;
    const mxArray *c4_c_y = NULL;
    real_T *c4_P_Elec;
    c4_P_Elec = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
    c4_st = NULL;
    c4_st = NULL;
    c4_y = NULL;
    sf_mex_assign(&c4_y, sf_mex_createcellarray(2), FALSE);
    c4_hoistedGlobal = *c4_P_Elec;
    c4_u = c4_hoistedGlobal;
    c4_b_y = NULL;
    sf_mex_assign(&c4_b_y, sf_mex_create("y", &c4_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_setcell(c4_y, 0, c4_b_y);
    c4_b_hoistedGlobal = chartInstance->c4_is_active_c4_Zigor_Model;
    c4_b_u = c4_b_hoistedGlobal;
    c4_c_y = NULL;
    sf_mex_assign(&c4_c_y, sf_mex_create("y", &c4_b_u, 3, 0U, 0U, 0U, 0), FALSE);
    sf_mex_setcell(c4_y, 1, c4_c_y);
    sf_mex_assign(&c4_st, c4_y, FALSE);
    return c4_st;
}

static void set_sim_state_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_st)
{
    const mxArray *c4_u;
    real_T *c4_P_Elec;
    c4_P_Elec = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
    chartInstance->c4_doneDoubleBufferReInit = TRUE;
    c4_u = sf_mex_dup(c4_st);
    *c4_P_Elec = c4_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c4_u, 0)), "P_Elec");
    chartInstance->c4_is_active_c4_Zigor_Model = c4_f_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c4_u, 1)), "is_active_c4_Zigor_Model");
    sf_mex_destroy(&c4_u);
    c4_update_debugger_state_c4_Zigor_Model(chartInstance);
    sf_mex_destroy(&c4_st);
}


static void finalize_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

static void sf_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    int32_T c4_i0;
    real_T *c4_P_Elec;
    real_T (*c4_u)[10];
    c4_P_Elec = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
    c4_u = (real_T (*)[10])ssGetInputPortSignal(chartInstance->S, 0);
    _sfTime_ = (real_T)ssGetT(chartInstance->S);
    _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 0U, chartInstance->c4_sfEvent);
    for (c4_i0 = 0; c4_i0 < 10; c4_i0++) {
        _SFD_DATA_RANGE_CHECK((*c4_u)[c4_i0], 0U);
    }
    _SFD_DATA_RANGE_CHECK(*c4_P_Elec, 1U);
    chartInstance->c4_sfEvent = CALL_EVENT;
    c4_chartstep_c4_Zigor_Model(chartInstance);
    sf_debug_check_for_state_inconsistency(_Zigor_ModelMachineNumber_, chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c4_chartstep_c4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
    int32_T c4_i1;
    real_T c4_u[10];
    uint32_T c4_debug_family_var_map[8];
    c4_sao7lvpULMJbzgO3vhk2pkD c4_Param;
    real_T c4_PowSolar_PV;
    real_T c4_PV_Ctl;
    real_T c4_PV_Shaving_Ctl;
    real_T c4_nargin = 1.0;
    real_T c4_nargout = 1.0;
    real_T c4_P_Elec;
    c4_sao7lvpULMJbzgO3vhk2pkD c4_b_Param;
    real_T c4_b_PowSolar_PV;
    real_T c4_b_PV_Ctl;
    real_T c4_b_PV_Shaving_Ctl;
    real_T c4_State;
    real_T c4_A;
    real_T c4_B;
    real_T c4_x;
    real_T c4_y;
    real_T c4_b_x;
    real_T c4_b_y;
    real_T c4_ppv;
    real_T c4_b_A;
    real_T c4_b_B;
    real_T c4_c_x;
    real_T c4_c_y;
    real_T c4_d_x;
    real_T c4_d_y;
    real_T c4_p0;
    real_T c4_b;
    real_T c4_e_y;
    real_T c4_b_b;
    real_T c4_f_y;
    real_T c4_a;
    real_T c4_c_b;
    real_T c4_g_y;
    real_T c4_b_a;
    real_T c4_d_b;
    real_T c4_h_y;
    real_T c4_e_b;
    real_T c4_i_y;
    real_T c4_c_a;
    real_T c4_f_b;
    real_T c4_j_y;
    real_T c4_d_a;
    real_T c4_g_b;
    real_T c4_k_y;
    real_T c4_c_A;
    real_T c4_c_B;
    real_T c4_e_x;
    real_T c4_l_y;
    real_T c4_f_x;
    real_T c4_m_y;
    real_T c4_e_a;
    real_T c4_h_b;
    real_T c4_n_y;
    real_T c4_i_b;
    real_T c4_o_y;
    real_T c4_f_a;
    real_T c4_j_b;
    real_T c4_p_y;
    real_T c4_g_a;
    real_T c4_k_b;
    real_T c4_q_y;
    real_T c4_h_a;
    real_T c4_l_b;
    real_T c4_r_y;
    real_T c4_d_A;
    real_T c4_d_B;
    real_T c4_g_x;
    real_T c4_s_y;
    real_T c4_h_x;
    real_T c4_t_y;
    real_T c4_m_b;
    real_T c4_i_a;
    real_T c4_n_b;
    real_T c4_u_y;
    real_T c4_e_A;
    real_T c4_e_B;
    real_T c4_i_x;
    real_T c4_v_y;
    real_T c4_j_x;
    real_T c4_w_y;
    real_T c4_x_y;
    real_T c4_j_a;
    real_T c4_o_b;
    real_T c4_y_y;
    real_T c4_k_a;
    real_T c4_p_b;
    real_T c4_ab_y;
    real_T c4_varargin_1;
    real_T c4_varargin_2;
    real_T c4_b_varargin_2;
    real_T c4_varargin_3;
    real_T c4_k_x;
    real_T c4_bb_y;
    real_T c4_l_x;
    real_T c4_cb_y;
    real_T c4_xk;
    real_T c4_yk;
    real_T c4_m_x;
    real_T c4_db_y;
    real_T c4_minval;
    real_T *c4_b_P_Elec;
    real_T (*c4_b_u)[10];
    c4_b_P_Elec = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
    c4_b_u = (real_T (*)[10])ssGetInputPortSignal(chartInstance->S, 0);
    _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c4_sfEvent);
    for (c4_i1 = 0; c4_i1 < 10; c4_i1++) {
        c4_u[c4_i1] = (*c4_b_u)[c4_i1];
    }
    sf_debug_symbol_scope_push_eml(0U, 8U, 8U, c4_debug_family_names, c4_debug_family_var_map);
    sf_debug_symbol_scope_add_eml_importable(&c4_Param, 0U, c4_c_sf_marshallOut, c4_b_sf_marshallIn);
    sf_debug_symbol_scope_add_eml_importable(&c4_PowSolar_PV, 1U, c4_sf_marshallOut, c4_sf_marshallIn);
    sf_debug_symbol_scope_add_eml_importable(&c4_PV_Ctl, 2U, c4_sf_marshallOut, c4_sf_marshallIn);
    sf_debug_symbol_scope_add_eml_importable(&c4_PV_Shaving_Ctl, 3U, c4_sf_marshallOut, c4_sf_marshallIn);
    sf_debug_symbol_scope_add_eml_importable(&c4_nargin, 4U, c4_sf_marshallOut, c4_sf_marshallIn);
    sf_debug_symbol_scope_add_eml_importable(&c4_nargout, 5U, c4_sf_marshallOut, c4_sf_marshallIn);
    sf_debug_symbol_scope_add_eml(c4_u, 6U, c4_b_sf_marshallOut);
    sf_debug_symbol_scope_add_eml_importable(&c4_P_Elec, 7U, c4_sf_marshallOut, c4_sf_marshallIn);
    CV_EML_FCN(0, 0);
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 2);
    c4_Param.nPW = c4_u[0];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 3);
    c4_Param.Eff.Ploss_off = c4_u[1];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 4);
    c4_Param.Eff.Ploss_on = c4_u[2];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 5);
    c4_Param.Eff.Eff_hl = c4_u[3];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 6);
    c4_Param.Eff.Eff_fl = c4_u[4];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 7);
    c4_Param.MinPVPW_On = c4_u[5];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 8);
    c4_Param.MinPVPW_av = c4_u[6];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 9);
    c4_PowSolar_PV = c4_u[7];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 10);
    c4_PV_Ctl = c4_u[8];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 11);
    c4_PV_Shaving_Ctl = c4_u[9];
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 14);
    c4_b_Param = c4_Param;
    c4_b_PowSolar_PV = c4_PowSolar_PV;
    c4_b_PV_Ctl = c4_PV_Ctl;
    c4_b_PV_Shaving_Ctl = c4_PV_Shaving_Ctl;
    if (c4_b_PowSolar_PV < c4_b_Param.MinPVPW_av) {
        c4_P_Elec = 0.0;
    } else {
        switch ((int32_T)_SFD_INTEGER_CHECK("", c4_b_PV_Ctl)) {
          case 0:
            c4_State = 2.0;
            break;
          default:
            if (c4_b_PowSolar_PV < c4_b_Param.MinPVPW_On) {
                c4_State = 3.0;
            } else {
                c4_State = 4.0;
            }
            break;
        }
        switch ((int32_T)_SFD_INTEGER_CHECK("", c4_State)) {
          case 4:
            c4_A = c4_b_PowSolar_PV;
            c4_B = c4_b_Param.nPW;
            c4_x = c4_A;
            c4_y = c4_B;
            c4_b_x = c4_x;
            c4_b_y = c4_y;
            c4_ppv = c4_b_x / c4_b_y;
            c4_b_A = c4_b_Param.Eff.Ploss_on;
            c4_b_B = c4_b_Param.nPW;
            c4_c_x = c4_b_A;
            c4_c_y = c4_b_B;
            c4_d_x = c4_c_x;
            c4_d_y = c4_c_y;
            c4_p0 = c4_d_x / c4_d_y;
            c4_b = c4_b_Param.Eff.Eff_fl;
            c4_e_y = 200.0 * c4_b;
            c4_b_b = c4_p0;
            c4_f_y = 3.0 * c4_b_b;
            c4_a = c4_f_y;
            c4_c_b = c4_b_Param.Eff.Eff_hl;
            c4_g_y = c4_a * c4_c_b;
            c4_b_a = c4_g_y;
            c4_d_b = c4_b_Param.Eff.Eff_fl;
            c4_h_y = c4_b_a * c4_d_b;
            c4_e_b = c4_b_Param.Eff.Eff_hl;
            c4_i_y = 100.0 * c4_e_b;
            c4_c_a = c4_b_Param.Eff.Eff_hl;
            c4_f_b = c4_b_Param.Eff.Eff_fl;
            c4_j_y = c4_c_a * c4_f_b;
            c4_d_a = c4_b_Param.Eff.Eff_hl;
            c4_g_b = c4_b_Param.Eff.Eff_fl;
            c4_k_y = c4_d_a * c4_g_b;
            c4_c_A = ((c4_e_y - c4_h_y) - c4_i_y) - c4_j_y;
            c4_c_B = c4_k_y;
            c4_e_x = c4_c_A;
            c4_l_y = c4_c_B;
            c4_f_x = c4_e_x;
            c4_m_y = c4_l_y;
            c4_e_a = c4_f_x / c4_m_y;
            c4_h_b = c4_b_Param.Eff.Eff_hl - c4_b_Param.Eff.Eff_fl;
            c4_n_y = 200.0 * c4_h_b;
            c4_i_b = c4_p0;
            c4_o_y = 2.0 * c4_i_b;
            c4_f_a = c4_o_y;
            c4_j_b = c4_b_Param.Eff.Eff_hl;
            c4_p_y = c4_f_a * c4_j_b;
            c4_g_a = c4_p_y;
            c4_k_b = c4_b_Param.Eff.Eff_fl;
            c4_q_y = c4_g_a * c4_k_b;
            c4_h_a = c4_b_Param.Eff.Eff_hl;
            c4_l_b = c4_b_Param.Eff.Eff_fl;
            c4_r_y = c4_h_a * c4_l_b;
            c4_d_A = c4_n_y + c4_q_y;
            c4_d_B = c4_r_y;
            c4_g_x = c4_d_A;
            c4_s_y = c4_d_B;
            c4_h_x = c4_g_x;
            c4_t_y = c4_s_y;
            c4_m_b = c4_h_x / c4_t_y;
            c4_mpower(chartInstance, c4_ppv);
            c4_i_a = c4_b_PowSolar_PV;
            c4_n_b = 1.0 - c4_e_a;
            c4_u_y = c4_i_a * c4_n_b;
            c4_e_A = c4_mpower(chartInstance, c4_b_PowSolar_PV);
            c4_e_B = c4_b_Param.nPW;
            c4_i_x = c4_e_A;
            c4_v_y = c4_e_B;
            c4_j_x = c4_i_x;
            c4_w_y = c4_v_y;
            c4_x_y = c4_j_x / c4_w_y;
            c4_j_a = c4_x_y;
            c4_o_b = c4_m_b;
            c4_y_y = c4_j_a * c4_o_b;
            c4_P_Elec = (c4_u_y - c4_y_y) - c4_b_Param.Eff.Ploss_on;
            c4_k_a = c4_b_PV_Shaving_Ctl;
            c4_p_b = c4_b_Param.nPW;
            c4_ab_y = c4_k_a * c4_p_b;
            c4_varargin_1 = c4_P_Elec;
            c4_varargin_2 = c4_ab_y;
            c4_b_varargin_2 = c4_varargin_1;
            c4_varargin_3 = c4_varargin_2;
            c4_k_x = c4_b_varargin_2;
            c4_bb_y = c4_varargin_3;
            c4_l_x = c4_k_x;
            c4_cb_y = c4_bb_y;
            c4_eml_scalar_eg(chartInstance);
            c4_xk = c4_l_x;
            c4_yk = c4_cb_y;
            c4_m_x = c4_xk;
            c4_db_y = c4_yk;
            c4_eml_scalar_eg(chartInstance);
            c4_minval = muDoubleScalarMin(c4_m_x, c4_db_y);
            c4_P_Elec = -c4_minval;
            break;
          default:
            c4_P_Elec = c4_b_Param.Eff.Ploss_off;
            break;
        }
    }
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -14);
    sf_debug_symbol_scope_pop();
    *c4_b_P_Elec = c4_P_Elec;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c4_sfEvent);
}

static void initSimStructsc4_Zigor_Model(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c4_machineNumber, uint32_T c4_chartNumber)
{
}

static const mxArray *c4_sf_marshallOut(void *chartInstanceVoid, void *c4_inData)
{
    const mxArray *c4_mxArrayOutData = NULL;
    real_T c4_u;
    const mxArray *c4_y = NULL;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_mxArrayOutData = NULL;
    c4_u = *(real_T *)c4_inData;
    c4_y = NULL;
    sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_assign(&c4_mxArrayOutData, c4_y, FALSE);
    return c4_mxArrayOutData;
}

static real_T c4_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_P_Elec, const char_T *c4_identifier)
{
    real_T c4_y;
    emlrtMsgIdentifier c4_thisId;
    c4_thisId.fIdentifier = c4_identifier;
    c4_thisId.fParent = NULL;
    c4_y = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_P_Elec), &c4_thisId);
    sf_mex_destroy(&c4_P_Elec);
    return c4_y;
}

static real_T c4_b_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
    real_T c4_y;
    real_T c4_d0;
    sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_d0, 1, 0, 0U, 0, 0U, 0);
    c4_y = c4_d0;
    sf_mex_destroy(&c4_u);
    return c4_y;
}

static void c4_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
    const mxArray *c4_P_Elec;
    const char_T *c4_identifier;
    emlrtMsgIdentifier c4_thisId;
    real_T c4_y;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_P_Elec = sf_mex_dup(c4_mxArrayInData);
    c4_identifier = c4_varName;
    c4_thisId.fIdentifier = c4_identifier;
    c4_thisId.fParent = NULL;
    c4_y = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_P_Elec), &c4_thisId);
    sf_mex_destroy(&c4_P_Elec);
    *(real_T *)c4_outData = c4_y;
    sf_mex_destroy(&c4_mxArrayInData);
}

static const mxArray *c4_b_sf_marshallOut(void *chartInstanceVoid, void *c4_inData)
{
    const mxArray *c4_mxArrayOutData = NULL;
    int32_T c4_i2;
    real_T c4_b_inData[10];
    int32_T c4_i3;
    real_T c4_u[10];
    const mxArray *c4_y = NULL;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_mxArrayOutData = NULL;
    for (c4_i2 = 0; c4_i2 < 10; c4_i2++) {
        c4_b_inData[c4_i2] = (*(real_T (*)[10])c4_inData)[c4_i2];
    }
    for (c4_i3 = 0; c4_i3 < 10; c4_i3++) {
        c4_u[c4_i3] = c4_b_inData[c4_i3];
    }
    c4_y = NULL;
    sf_mex_assign(&c4_y, sf_mex_create("y", c4_u, 0, 0U, 1U, 0U, 1, 10), FALSE);
    sf_mex_assign(&c4_mxArrayOutData, c4_y, FALSE);
    return c4_mxArrayOutData;
}

static const mxArray *c4_c_sf_marshallOut(void *chartInstanceVoid, void *c4_inData)
{
    const mxArray *c4_mxArrayOutData;
    c4_sao7lvpULMJbzgO3vhk2pkD c4_u;
    const mxArray *c4_y = NULL;
    real_T c4_b_u;
    const mxArray *c4_b_y = NULL;
    c4_szlnHL9Df6pKpDV9xqQkSJG c4_c_u;
    const mxArray *c4_c_y = NULL;
    real_T c4_d_u;
    const mxArray *c4_d_y = NULL;
    real_T c4_e_u;
    const mxArray *c4_e_y = NULL;
    real_T c4_f_u;
    const mxArray *c4_f_y = NULL;
    real_T c4_g_u;
    const mxArray *c4_g_y = NULL;
    real_T c4_h_u;
    const mxArray *c4_h_y = NULL;
    real_T c4_i_u;
    const mxArray *c4_i_y = NULL;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_mxArrayOutData = NULL;
    c4_mxArrayOutData = NULL;
    c4_u = *(c4_sao7lvpULMJbzgO3vhk2pkD *)c4_inData;
    c4_y = NULL;
    sf_mex_assign(&c4_y, sf_mex_createstruct("structure", 2, 1, 1), FALSE);
    c4_b_u = c4_u.nPW;
    c4_b_y = NULL;
    sf_mex_assign(&c4_b_y, sf_mex_create("y", &c4_b_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_y, c4_b_y, "nPW", "nPW", 0);
    c4_c_u = c4_u.Eff;
    c4_c_y = NULL;
    sf_mex_assign(&c4_c_y, sf_mex_createstruct("structure", 2, 1, 1), FALSE);
    c4_d_u = c4_c_u.Ploss_off;
    c4_d_y = NULL;
    sf_mex_assign(&c4_d_y, sf_mex_create("y", &c4_d_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_c_y, c4_d_y, "Ploss_off", "Ploss_off", 0);
    c4_e_u = c4_c_u.Ploss_on;
    c4_e_y = NULL;
    sf_mex_assign(&c4_e_y, sf_mex_create("y", &c4_e_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_c_y, c4_e_y, "Ploss_on", "Ploss_on", 0);
    c4_f_u = c4_c_u.Eff_hl;
    c4_f_y = NULL;
    sf_mex_assign(&c4_f_y, sf_mex_create("y", &c4_f_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_c_y, c4_f_y, "Eff_hl", "Eff_hl", 0);
    c4_g_u = c4_c_u.Eff_fl;
    c4_g_y = NULL;
    sf_mex_assign(&c4_g_y, sf_mex_create("y", &c4_g_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_c_y, c4_g_y, "Eff_fl", "Eff_fl", 0);
    sf_mex_addfield(c4_y, c4_c_y, "Eff", "Eff", 0);
    c4_h_u = c4_u.MinPVPW_On;
    c4_h_y = NULL;
    sf_mex_assign(&c4_h_y, sf_mex_create("y", &c4_h_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_y, c4_h_y, "MinPVPW_On", "MinPVPW_On", 0);
    c4_i_u = c4_u.MinPVPW_av;
    c4_i_y = NULL;
    sf_mex_assign(&c4_i_y, sf_mex_create("y", &c4_i_u, 0, 0U, 0U, 0U, 0), FALSE);
    sf_mex_addfield(c4_y, c4_i_y, "MinPVPW_av", "MinPVPW_av", 0);
    sf_mex_assign(&c4_mxArrayOutData, c4_y, FALSE);
    return c4_mxArrayOutData;
}

static c4_sao7lvpULMJbzgO3vhk2pkD c4_c_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
    c4_sao7lvpULMJbzgO3vhk2pkD c4_y;
    emlrtMsgIdentifier c4_thisId;
    static const char * c4_fieldNames[4] = { "nPW", "Eff", "MinPVPW_On", "MinPVPW_av" };
    c4_thisId.fParent = c4_parentId;
    sf_mex_check_struct(c4_parentId, c4_u, 4, c4_fieldNames, 0U, 0);
    c4_thisId.fIdentifier = "nPW";
    c4_y.nPW = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "nPW", "nPW", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "Eff";
    c4_y.Eff = c4_d_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "Eff", "Eff", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "MinPVPW_On";
    c4_y.MinPVPW_On = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "MinPVPW_On", "MinPVPW_On", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "MinPVPW_av";
    c4_y.MinPVPW_av = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "MinPVPW_av", "MinPVPW_av", 0)), &c4_thisId);
    sf_mex_destroy(&c4_u);
    return c4_y;
}

static c4_szlnHL9Df6pKpDV9xqQkSJG c4_d_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
    c4_szlnHL9Df6pKpDV9xqQkSJG c4_y;
    emlrtMsgIdentifier c4_thisId;
    static const char * c4_fieldNames[4] = { "Ploss_off", "Ploss_on", "Eff_hl", "Eff_fl" };
    c4_thisId.fParent = c4_parentId;
    sf_mex_check_struct(c4_parentId, c4_u, 4, c4_fieldNames, 0U, 0);
    c4_thisId.fIdentifier = "Ploss_off";
    c4_y.Ploss_off = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "Ploss_off", "Ploss_off", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "Ploss_on";
    c4_y.Ploss_on = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "Ploss_on", "Ploss_on", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "Eff_hl";
    c4_y.Eff_hl = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "Eff_hl", "Eff_hl", 0)), &c4_thisId);
    c4_thisId.fIdentifier = "Eff_fl";
    c4_y.Eff_fl = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getfield(c4_u, "Eff_fl", "Eff_fl", 0)), &c4_thisId);
    sf_mex_destroy(&c4_u);
    return c4_y;
}

static void c4_b_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
    const mxArray *c4_Param;
    const char_T *c4_identifier;
    emlrtMsgIdentifier c4_thisId;
    c4_sao7lvpULMJbzgO3vhk2pkD c4_y;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_Param = sf_mex_dup(c4_mxArrayInData);
    c4_identifier = c4_varName;
    c4_thisId.fIdentifier = c4_identifier;
    c4_thisId.fParent = NULL;
    c4_y = c4_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_Param), &c4_thisId);
    sf_mex_destroy(&c4_Param);
    *(c4_sao7lvpULMJbzgO3vhk2pkD *)c4_outData = c4_y;
    sf_mex_destroy(&c4_mxArrayInData);
}

const mxArray *sf_c4_Zigor_Model_get_eml_resolved_functions_info(void)
{
    const mxArray *c4_nameCaptureInfo;
    c4_ResolvedFunctionInfo c4_info[17];
    const mxArray *c4_m0 = NULL;
    int32_T c4_i4;
    c4_ResolvedFunctionInfo *c4_r0;
    c4_nameCaptureInfo = NULL;
    c4_nameCaptureInfo = NULL;
    c4_info_helper(c4_info);
    sf_mex_assign(&c4_m0, sf_mex_createstruct("nameCaptureInfo", 1, 17), FALSE);
    for (c4_i4 = 0; c4_i4 < 17; c4_i4++) {
        c4_r0 = &c4_info[c4_i4];
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", c4_r0->context, 15, 0U, 0U, 0U, 2, 1, strlen(c4_r0->context)), "context", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", c4_r0->name, 15, 0U, 0U, 0U, 2, 1, strlen(c4_r0->name)), "name", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", c4_r0->dominantType, 15, 0U, 0U, 0U, 2, 1, strlen(c4_r0->dominantType)), "dominantType", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", c4_r0->resolved, 15, 0U, 0U, 0U, 2, 1, strlen(c4_r0->resolved)), "resolved", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", &c4_r0->fileTimeLo, 7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", &c4_r0->fileTimeHi, 7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", &c4_r0->mFileTimeLo, 7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c4_i4);
        sf_mex_addfield(c4_m0, sf_mex_create("nameCaptureInfo", &c4_r0->mFileTimeHi, 7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c4_i4);
    }
    sf_mex_assign(&c4_nameCaptureInfo, c4_m0, FALSE);
    sf_mex_emlrtNameCapturePostProcessR2012a(&c4_nameCaptureInfo);
    return c4_nameCaptureInfo;
}

static void c4_info_helper(c4_ResolvedFunctionInfo c4_info[17])
{
    c4_info[0].context = "";
    c4_info[0].name = "PowElec_PV";
    c4_info[0].dominantType = "struct";
    c4_info[0].resolved = "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowElec_PV.p";
    c4_info[0].fileTimeLo = 1392628890U;
    c4_info[0].fileTimeHi = 0U;
    c4_info[0].mFileTimeLo = 0U;
    c4_info[0].mFileTimeHi = 0U;
    c4_info[1].context = "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowElec_PV.p";
    c4_info[1].name = "mrdivide";
    c4_info[1].dominantType = "double";
    c4_info[1].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
    c4_info[1].fileTimeLo = 1342810944U;
    c4_info[1].fileTimeHi = 0U;
    c4_info[1].mFileTimeLo = 1319729966U;
    c4_info[1].mFileTimeHi = 0U;
    c4_info[2].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
    c4_info[2].name = "rdivide";
    c4_info[2].dominantType = "double";
    c4_info[2].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
    c4_info[2].fileTimeLo = 1286818844U;
    c4_info[2].fileTimeHi = 0U;
    c4_info[2].mFileTimeLo = 0U;
    c4_info[2].mFileTimeHi = 0U;
    c4_info[3].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
    c4_info[3].name = "eml_div";
    c4_info[3].dominantType = "double";
    c4_info[3].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
    c4_info[3].fileTimeLo = 1313347810U;
    c4_info[3].fileTimeHi = 0U;
    c4_info[3].mFileTimeLo = 0U;
    c4_info[3].mFileTimeHi = 0U;
    c4_info[4].context = "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowElec_PV.p";
    c4_info[4].name = "mtimes";
    c4_info[4].dominantType = "double";
    c4_info[4].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
    c4_info[4].fileTimeLo = 1289519692U;
    c4_info[4].fileTimeHi = 0U;
    c4_info[4].mFileTimeLo = 0U;
    c4_info[4].mFileTimeHi = 0U;
    c4_info[5].context = "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowElec_PV.p";
    c4_info[5].name = "mpower";
    c4_info[5].dominantType = "double";
    c4_info[5].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
    c4_info[5].fileTimeLo = 1286818842U;
    c4_info[5].fileTimeHi = 0U;
    c4_info[5].mFileTimeLo = 0U;
    c4_info[5].mFileTimeHi = 0U;
    c4_info[6].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
    c4_info[6].name = "power";
    c4_info[6].dominantType = "double";
    c4_info[6].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
    c4_info[6].fileTimeLo = 1336522096U;
    c4_info[6].fileTimeHi = 0U;
    c4_info[6].mFileTimeLo = 0U;
    c4_info[6].mFileTimeHi = 0U;
    c4_info[7].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
    c4_info[7].name = "eml_scalar_eg";
    c4_info[7].dominantType = "double";
    c4_info[7].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
    c4_info[7].fileTimeLo = 1286818796U;
    c4_info[7].fileTimeHi = 0U;
    c4_info[7].mFileTimeLo = 0U;
    c4_info[7].mFileTimeHi = 0U;
    c4_info[8].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
    c4_info[8].name = "eml_scalexp_alloc";
    c4_info[8].dominantType = "double";
    c4_info[8].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
    c4_info[8].fileTimeLo = 1330608434U;
    c4_info[8].fileTimeHi = 0U;
    c4_info[8].mFileTimeLo = 0U;
    c4_info[8].mFileTimeHi = 0U;
    c4_info[9].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
    c4_info[9].name = "floor";
    c4_info[9].dominantType = "double";
    c4_info[9].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
    c4_info[9].fileTimeLo = 1286818742U;
    c4_info[9].fileTimeHi = 0U;
    c4_info[9].mFileTimeLo = 0U;
    c4_info[9].mFileTimeHi = 0U;
    c4_info[10].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
    c4_info[10].name = "eml_scalar_floor";
    c4_info[10].dominantType = "double";
    c4_info[10].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
    c4_info[10].fileTimeLo = 1286818726U;
    c4_info[10].fileTimeHi = 0U;
    c4_info[10].mFileTimeLo = 0U;
    c4_info[10].mFileTimeHi = 0U;
    c4_info[11].context = "[E]C:/Users/iepzugue/Desktop/Zigor/Test_PV_Zigor_2.2.0.0 Version2/EkaitzCode/PowElec_PV.p";
    c4_info[11].name = "min";
    c4_info[11].dominantType = "double";
    c4_info[11].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
    c4_info[11].fileTimeLo = 1311255318U;
    c4_info[11].fileTimeHi = 0U;
    c4_info[11].mFileTimeLo = 0U;
    c4_info[11].mFileTimeHi = 0U;
    c4_info[12].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
    c4_info[12].name = "eml_min_or_max";
    c4_info[12].dominantType = "char";
    c4_info[12].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
    c4_info[12].fileTimeLo = 1334071490U;
    c4_info[12].fileTimeHi = 0U;
    c4_info[12].mFileTimeLo = 0U;
    c4_info[12].mFileTimeHi = 0U;
    c4_info[13].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
    c4_info[13].name = "eml_scalar_eg";
    c4_info[13].dominantType = "double";
    c4_info[13].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
    c4_info[13].fileTimeLo = 1286818796U;
    c4_info[13].fileTimeHi = 0U;
    c4_info[13].mFileTimeLo = 0U;
    c4_info[13].mFileTimeHi = 0U;
    c4_info[14].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
    c4_info[14].name = "eml_scalexp_alloc";
    c4_info[14].dominantType = "double";
    c4_info[14].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
    c4_info[14].fileTimeLo = 1330608434U;
    c4_info[14].fileTimeHi = 0U;
    c4_info[14].mFileTimeLo = 0U;
    c4_info[14].mFileTimeHi = 0U;
    c4_info[15].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum";
    c4_info[15].name = "eml_index_class";
    c4_info[15].dominantType = "";
    c4_info[15].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
    c4_info[15].fileTimeLo = 1323170578U;
    c4_info[15].fileTimeHi = 0U;
    c4_info[15].mFileTimeLo = 0U;
    c4_info[15].mFileTimeHi = 0U;
    c4_info[16].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_scalar_bin_extremum";
    c4_info[16].name = "eml_scalar_eg";
    c4_info[16].dominantType = "double";
    c4_info[16].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
    c4_info[16].fileTimeLo = 1286818796U;
    c4_info[16].fileTimeHi = 0U;
    c4_info[16].mFileTimeLo = 0U;
    c4_info[16].mFileTimeHi = 0U;
}

static real_T c4_mpower(SFc4_Zigor_ModelInstanceStruct *chartInstance, real_T c4_a)
{
    real_T c4_b_a;
    real_T c4_c_a;
    real_T c4_ak;
    c4_b_a = c4_a;
    c4_c_a = c4_b_a;
    c4_eml_scalar_eg(chartInstance);
    c4_ak = c4_c_a;
    return muDoubleScalarPower(c4_ak, 2.0);
}

static void c4_eml_scalar_eg(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

static const mxArray *c4_d_sf_marshallOut(void *chartInstanceVoid, void *c4_inData)
{
    const mxArray *c4_mxArrayOutData = NULL;
    int32_T c4_u;
    const mxArray *c4_y = NULL;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_mxArrayOutData = NULL;
    c4_u = *(int32_T *)c4_inData;
    c4_y = NULL;
    sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 6, 0U, 0U, 0U, 0), FALSE);
    sf_mex_assign(&c4_mxArrayOutData, c4_y, FALSE);
    return c4_mxArrayOutData;
}

static int32_T c4_e_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
    int32_T c4_y;
    int32_T c4_i5;
    sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_i5, 1, 6, 0U, 0, 0U, 0);
    c4_y = c4_i5;
    sf_mex_destroy(&c4_u);
    return c4_y;
}

static void c4_c_sf_marshallIn(void *chartInstanceVoid, const mxArray *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
    const mxArray *c4_b_sfEvent;
    const char_T *c4_identifier;
    emlrtMsgIdentifier c4_thisId;
    int32_T c4_y;
    SFc4_Zigor_ModelInstanceStruct *chartInstance;
    chartInstance = (SFc4_Zigor_ModelInstanceStruct *)chartInstanceVoid;
    c4_b_sfEvent = sf_mex_dup(c4_mxArrayInData);
    c4_identifier = c4_varName;
    c4_thisId.fIdentifier = c4_identifier;
    c4_thisId.fParent = NULL;
    c4_y = c4_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_b_sfEvent), &c4_thisId);
    sf_mex_destroy(&c4_b_sfEvent);
    *(int32_T *)c4_outData = c4_y;
    sf_mex_destroy(&c4_mxArrayInData);
}

static uint8_T c4_f_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_b_is_active_c4_Zigor_Model, const char_T *c4_identifier)
{
    uint8_T c4_y;
    emlrtMsgIdentifier c4_thisId;
    c4_thisId.fIdentifier = c4_identifier;
    c4_thisId.fParent = NULL;
    c4_y = c4_g_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_b_is_active_c4_Zigor_Model), &c4_thisId);
    sf_mex_destroy(&c4_b_is_active_c4_Zigor_Model);
    return c4_y;
}

static uint8_T c4_g_emlrt_marshallIn(SFc4_Zigor_ModelInstanceStruct *chartInstance, const mxArray *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
    uint8_T c4_y;
    uint8_T c4_u0;
    sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_u0, 1, 3, 0U, 0, 0U, 0);
    c4_y = c4_u0;
    sf_mex_destroy(&c4_u);
    return c4_y;
}

static void init_dsm_address_info(SFc4_Zigor_ModelInstanceStruct *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c4_Zigor_Model_get_check_sum(mxArray *plhs[])
{
         ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2958334760U);
         ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3361865174U);
         ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2259992880U);
         ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3313197982U);
}

mxArray *sf_c4_Zigor_Model_get_autoinheritance_info(void)
{
     const char *autoinheritanceFields[] = {"checksum","inputs","parameters","outputs","locals"};
     mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,autoinheritanceFields);
     {
         mxArray *mxChecksum = mxCreateString("rr6BjeMPO7lOignavXvPPC");
         mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
     }
 {
         const char *dataFields[] = {"size","type","complexity"};
         mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);
             {
                 mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
                 double *pr = mxGetPr(mxSize);
                 pr[0] = (double)(10);
                 pr[1] = (double)(1);
                 mxSetField(mxData,0,"size",mxSize);
             }            
             {
                 const char *typeFields[] = {"base","fixpt"};
                 mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
                 mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
                     mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
                 mxSetField(mxData,0,"type",mxType);
             }                        
             mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
         mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
 }
 {
         mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,mxREAL));            
 }
 {
         const char *dataFields[] = {"size","type","complexity"};
         mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);
             {
                 mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
                 double *pr = mxGetPr(mxSize);
                 pr[0] = (double)(1);
                 pr[1] = (double)(1);
                 mxSetField(mxData,0,"size",mxSize);
             }            
             {
                 const char *typeFields[] = {"base","fixpt"};
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

static const mxArray *sf_get_sim_state_info_c4_Zigor_Model(void)
{
   const char *infoFields[] = {"chartChecksum", "varInfo"};
   mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
   const char *infoEncStr[] = {
   "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[9],T\"P_Elec\",},{M[8],M[0],T\"is_active_c4_Zigor_Model\",}}"
   };
   mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
   mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
   sf_c4_Zigor_Model_get_check_sum(&mxChecksum);
   mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
   mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
   return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int fullDebuggerInitialization)
{
   if(!sim_mode_is_rtw_gen(S)) {
        SFc4_Zigor_ModelInstanceStruct *chartInstance;
        chartInstance = (SFc4_Zigor_ModelInstanceStruct *) ((ChartInfoStruct *)(ssGetUserData(S)))->chartInstance;
     if(ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
        /* do this only if simulation is starting */
	{
	unsigned int chartAlreadyPresent;
	chartAlreadyPresent = sf_debug_initialize_chart(_Zigor_ModelMachineNumber_,
                                                   4,
                                                   1,
                                                   1,
                                                   2,
                                                   0,
                                                   0,
                                                   0,
                                                   0,
                                                   0,
                                                   &(chartInstance->chartNumber),
                                                   &(chartInstance->instanceNumber),
                                                   ssGetPath(S),
                                                   (void *)S);
	if(chartAlreadyPresent==0) {
	/* this is the first instance */
     init_script_number_translation(_Zigor_ModelMachineNumber_,chartInstance->chartNumber);
 sf_debug_set_chart_disable_implicit_casting(_Zigor_ModelMachineNumber_,chartInstance->chartNumber,1);
 sf_debug_set_chart_event_thresholds(_Zigor_ModelMachineNumber_,
                                     chartInstance->chartNumber,
                                     0,
                                     0,
                                     0);
 
	_SFD_SET_DATA_PROPS(0,1,1,0,"u");
	_SFD_SET_DATA_PROPS(1,2,0,1,"P_Elec");
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
 _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,334);
	_SFD_TRANS_COV_WTS(0,0,0,1,0);
	if(chartAlreadyPresent==0)
{
		_SFD_TRANS_COV_MAPS(0,
		0,NULL,NULL,
		0,NULL,NULL,
		1,NULL,NULL,
		0,NULL,NULL);
}
		    {
		unsigned int dimVector[1];
			    dimVector[0]= 10;
	_SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,1,&(dimVector[0]),0,0,0,0.0,1.0,0,0,(MexFcnForType)c4_b_sf_marshallOut,(MexInFcnForType)NULL);
		    }
	_SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,(MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
{
    real_T *c4_P_Elec;
    real_T (*c4_u)[10];
    c4_P_Elec = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
    c4_u = (real_T (*)[10])ssGetInputPortSignal(chartInstance->S, 0);
    _SFD_SET_DATA_VALUE_PTR(0U, *c4_u);
    _SFD_SET_DATA_VALUE_PTR(1U, c4_P_Elec);
}
}
     } else {
        sf_debug_reset_current_state_configuration(_Zigor_ModelMachineNumber_,chartInstance->chartNumber,chartInstance->instanceNumber);
     }
   }
}

static const char* sf_get_instance_specialization()
{
    return "3pf05y3O2w01esZ1x9v1T";
}

static void sf_opaque_initialize_c4_Zigor_Model(void *chartInstanceVar)
{
   chart_debug_initialization(((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar)->S,0);
   initialize_params_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
   initialize_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c4_Zigor_Model(void *chartInstanceVar)
{
   enable_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c4_Zigor_Model(void *chartInstanceVar)
{
   disable_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
}


static void sf_opaque_gateway_c4_Zigor_Model(void *chartInstanceVar)
{
   sf_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c4_Zigor_Model(SimStruct* S)
{
    ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
    mxArray *plhs[1] = {NULL};
    mxArray *prhs[4];
    int mxError = 0;

    prhs[0] = mxCreateString("chart_simctx_raw2high");
    prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
    prhs[2] = (mxArray*) get_sim_state_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*)chartInfo->chartInstance); /* raw sim ctx */
    prhs[3] = (mxArray*) sf_get_sim_state_info_c4_Zigor_Model(); /* state var info */

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

extern void sf_internal_set_sim_state_c4_Zigor_Model(SimStruct* S, const mxArray *st)
{
    ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
    mxArray *plhs[1] = {NULL};
    mxArray *prhs[4];
    int mxError = 0;
    
    prhs[0] = mxCreateString("chart_simctx_high2raw");
    prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
    prhs[2] = mxDuplicateArray(st); /* high level simctx */
    prhs[3] = (mxArray*) sf_get_sim_state_info_c4_Zigor_Model(); /* state var info */
    
    mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
    
    mxDestroyArray(prhs[0]);
    mxDestroyArray(prhs[1]);
    mxDestroyArray(prhs[2]);
    mxDestroyArray(prhs[3]);
    
    if (mxError || plhs[0] == NULL) {
        sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
    }
    
    set_sim_state_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*)chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
    mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c4_Zigor_Model(SimStruct* S)
{
    return sf_internal_get_sim_state_c4_Zigor_Model(S);
}

static void sf_opaque_set_sim_state_c4_Zigor_Model(SimStruct* S, const mxArray *st)
{
    sf_internal_set_sim_state_c4_Zigor_Model(S, st);
}

static void sf_opaque_terminate_c4_Zigor_Model(void *chartInstanceVar)
{
 if(chartInstanceVar!=NULL) {
     SimStruct *S = ((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar)->S;
     if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
         sf_clear_rtw_identifier(S);
     }
     finalize_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
     free((void *)chartInstanceVar);
     ssSetUserData(S,NULL);
 }
unload_Zigor_Model_optimization_info();
}


static void  sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
   initSimStructsc4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*) chartInstanceVar);
}
   
extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c4_Zigor_Model(SimStruct *S)
{
   int i;
   for(i=0;i<ssGetNumRunTimeParams(S);i++) {
      if(ssGetSFcnParamTunable(S,i)) {
         ssUpdateDlgParamAsRunTimeParam(S,i);
      }
   }
   if(sf_machine_global_initializer_called()) {
       initialize_params_c4_Zigor_Model((SFc4_Zigor_ModelInstanceStruct*)(((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
   }
}

static void mdlSetWorkWidths_c4_Zigor_Model(SimStruct *S)
{

 if(sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
     mxArray *infoStruct = load_Zigor_Model_optimization_info();
     int_T chartIsInlinable =
               (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,4);
     ssSetStateflowIsInlinable(S,chartIsInlinable);
		ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),infoStruct,4,"RTWCG"));
      ssSetEnableFcnIsTrivial(S,1);
      ssSetDisableFcnIsTrivial(S,1);
		ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),infoStruct,4,"gatewayCannotBeInlinedMultipleTimes"));
     if(chartIsInlinable) {            
           ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
             sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),infoStruct,4,1);
             sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),infoStruct,4,1);
     }
     sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,4);
     ssSetHasSubFunctions(S,!(chartIsInlinable));
 } else {
 }

     ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);

 ssSetChecksum0(S,(549597361U));
 ssSetChecksum1(S,(609204923U));
 ssSetChecksum2(S,(105497314U));
 ssSetChecksum3(S,(2955531616U));

 ssSetmdlDerivatives(S, NULL);

   ssSetExplicitFCSSCtrl(S,1);
   ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c4_Zigor_Model(SimStruct *S)
{
   if(sim_mode_is_rtw_gen(S)) {
	      ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
   }
      
}

static void mdlStart_c4_Zigor_Model(SimStruct *S)
{
 SFc4_Zigor_ModelInstanceStruct *chartInstance;
 chartInstance = (SFc4_Zigor_ModelInstanceStruct *)malloc(sizeof(SFc4_Zigor_ModelInstanceStruct));
 memset(chartInstance, 0, sizeof(SFc4_Zigor_ModelInstanceStruct));
 if(chartInstance==NULL) {
     sf_mex_error_message("Could not allocate memory for chart instance.");
 }
 chartInstance->chartInfo.chartInstance = chartInstance;
 chartInstance->chartInfo.isEMLChart = 1;
 chartInstance->chartInfo.chartInitialized = 0;
 chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c4_Zigor_Model;
 chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c4_Zigor_Model;
 chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c4_Zigor_Model;
 chartInstance->chartInfo.enableChart = sf_opaque_enable_c4_Zigor_Model;
 chartInstance->chartInfo.disableChart = sf_opaque_disable_c4_Zigor_Model;
 chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c4_Zigor_Model;
 chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c4_Zigor_Model;
 chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c4_Zigor_Model;
    chartInstance->chartInfo.zeroCrossings = NULL;
    chartInstance->chartInfo.outputs = NULL;
    chartInstance->chartInfo.derivatives = NULL;
 chartInstance->chartInfo.mdlRTW = mdlRTW_c4_Zigor_Model;
 chartInstance->chartInfo.mdlStart = mdlStart_c4_Zigor_Model;
 chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c4_Zigor_Model;
 chartInstance->chartInfo.extModeExec = NULL;
 chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
 chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
 chartInstance->chartInfo.storeCurrentConfiguration = NULL;
 chartInstance->S = S;
 ssSetUserData(S,(void *)(&(chartInstance->chartInfo))); /* register the chart instance with simstruct */

     init_dsm_address_info(chartInstance);
 if(!sim_mode_is_rtw_gen(S)) {
 }
   sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
   chart_debug_initialization(S,1);
}

void c4_Zigor_Model_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
  case SS_CALL_MDL_START:
    mdlStart_c4_Zigor_Model(S);
    break;
  case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c4_Zigor_Model(S);
    break;
  case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c4_Zigor_Model(S);
    break;
  default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c4_Zigor_Model_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}


