
typedef enum {
    IF_0,
    IF_1,
    IF_2,
    IF_3,
    IF_4,
    IF_5,
    IF_6,
    IF_7,
    IF_8,
    IF_9,
    IF_10,
    IF_11,
    IF_12,
    IF_13,
    IF_14,
    IF_15,
    IF_16,
    IF_17,
    IF_18,
    IF_19,
    IF_20,
    IF_21,
    IF_22,
    IF_23,
    IF_24,
    IF_25,
    IF_26,
    IF_27,
    IF_28,
    IF_29,
    IF_30,
    IF_31,
    IF_32,
    IF_33,
    IF_34,
    IF_35,
    IF_36,
    IF_37,
    IF_38,
    IF_39,
    IF_40,
    IF_41,
    IF_42,
    IF_43,
    IF_44,
    IF_45,
    IF_46,
    IF_47,
    IF_48,
    IF_49,
    IF_50,
    IF_51,
    IF_52,
    IF_53,
    IF_54,
    IF_55,
    IF_56,
    IF_57,
    IF_58,
    IF_59,
    IF_60,
    IF_61,
    IF_62,
    IF_63,
    IF_64,
    IF_65,
    IF_66,
    IF_67,
    IF_68,
    IF_69,
    IF_70,
    IF_71,
    IF_72,
    IF_73,
    IF_74,
    IF_75,
    IF_76,
    IF_77,
    IF_78,
    IF_79,
    IF_80,
    IF_81,
    IF_82,
    IF_83,
    IF_84,
    IF_85,
    IF_86,
    IF_87,
    IF_88,
    IF_89,
    IF_90,
    IF_91,
    IF_92,
    
    IF_93,
    IF_94,
    IF_95,
    IF_96,
    IF_97,
    IF_98,
    IF_99,
    IF_100,
    IF_101,
    IF_102,
    IF_103,
    IF_104,
    IF_105,
    IF_106,
    IF_107,
    IF_108,
    IF_109,
    IF_110,
    IF_111,
    IF_112,
    IF_113,
    
    IF_114,
    IF_115,
    IF_116,
    IF_117,
    IF_118,
    IF_119,
    IF_120,
    IF_121,
    IF_122,
    IF_123,
    
    IF_124,
    IF_125,
    IF_126,
    IF_127,
    IF_128,
    IF_129,
    IF_130,
    
    IF_131,
    IF_132,
    IF_133,
    IF_134,
    IF_135,
    IF_136,
    IF_137,
    IF_138,
    IF_139,
    IF_140,
    IF_141,
    IF_142,
    IF_143,
    IF_144,
    IF_145,
    IF_146,
    IF_147,
    IF_148,
    IF_149,
    IF_150,
    
    IF_151,
    IF_152,
    IF_153,
    IF_154,
    IF_155,
    IF_156,
    IF_157,
    
    IF_201,
    IF_202,
    IF_203,
    IF_204,
    IF_205,
    IF_206,
    IF_207,
    IF_208,
    IF_209,
    IF_210,
    IF_211,
    IF_212,
    IF_213,
    IF_214,
    IF_215,
    IF_216,
    IF_217,
    IF_218,
    IF_219,
    IF_220,
    IF_221,
    IF_222,
    IF_223,
    IF_224,
    IF_225,
    IF_226,
    IF_227,
    IF_228,
    IF_229,
    IF_230,
    IF_231,
    IF_232,
    IF_233,
    IF_234,
    IF_235,
    
    IF_236,
    IF_237,
    IF_238,
    IF_239,
    IF_240,
    IF_241,
    IF_242,
    IF_243,
    IF_244,
    IF_245,
    IF_246,
    IF_247,
    IF_248,
    IF_249,
    IF_250,
    
    IF_251,
    IF_252,
    IF_253,
    IF_254,
    IF_255,
    IF_256,
    IF_257,
    IF_258,
    
    IF_301,
    IF_302,
    IF_303,
    IF_304,
    IF_305,
    IF_306,
    IF_307,
    IF_308,
    IF_309,
    IF_310,
    IF_311,
    IF_312,
    IF_313,
    IF_314,
    IF_315,
    IF_316,
    IF_317,
    IF_318,
    IF_319,
    IF_320,
    IF_321,
    IF_322,
    IF_323,
    IF_324,
    IF_325,
    IF_326,
    IF_327,
    IF_328,
    IF_329,
    IF_330,
    IF_331,
    IF_332,
    IF_333,
    IF_334,
    IF_335,
    IF_336,
    IF_337,
    IF_338,
    IF_339,
    IF_340,
//    IF_temprature,
//    IF_fade,
//    IF_fogCircle,
//    IF_fogRectangle,
//    IF_vignette,
    NC_FILTER_TOTAL_NUMBER
} NCFilterType;

#import "UIImage+NC.h"
#import "NCImageFilter.h"
#import "NCVideoCamera.h"
#import "NCRotationFilter.h"
#import "NCNormalFilter.h"
#import "NCFNewFilter.h"
#import "IFShadowFilter.h"
#import "IFInkwellFilter.h"
#import "IFBrannanFilter.h"
#import "IFHefeFilter.h"
#import "IFNewTwoFilter.h"
#import "IFNewFilter.h"
#import "IFNewTfTwoFilter.h"
#import "IFLordKelvinFilter.h"