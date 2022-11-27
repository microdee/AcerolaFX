#include "AcerolaFX_Common.fxh"

uniform bool _UseFlow <
    ui_label = "Use Flow";
    ui_tooltip = "Whether or not to use the flow difference of gaussians or not.";
> = true;

uniform float _SigmaC <
    ui_category_closed = true;
    ui_category = "Edge Tangent Flow Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Tangent Flow Deviation";
    ui_type = "slider";
    ui_tooltip = "Adjust standard deviation for blurring of the structure tensor.";
> = 2.0f;

uniform float _SigmaM <
    ui_category_closed = true;
    ui_category = "Edge Tangent Flow Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Line Integral Deviation";
    ui_type = "slider";
    ui_tooltip = "Adjust standard deviation for smoothing of the flow difference of gaussians.";
> = 2.0f;

uniform float2 _LineIntegralStepSize <
    ui_category_closed = true;
    ui_category = "Edge Tangent Flow Settings";
    ui_label = "Line Convolution Step Sizes";
    ui_type = "drag";
    ui_tooltip = "Increase distance between smoothing samples for more painterly visuals.";
> = 1.0f;

uniform bool _CalcDiffBeforeConvolving <
    ui_category_closed = true;
    ui_category = "Edge Tangent Flow Settings";
    ui_label = "Calculate Difference Before Smoothing";
> = true;

uniform float _SigmaE <
    ui_category_closed = true;
    ui_category = "Difference Of Gaussians Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Difference Of Gaussians Deviation";
    ui_type = "slider";
    ui_tooltip = "Adjust the deviation of the color buffer gaussian blurring.";
> = 2.0f;

uniform float _K <
    ui_category_closed = true;
    ui_category = "Difference Of Gaussians Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Deviation Scale";
    ui_type = "drag";
    ui_tooltip = "Adjust scale between gaussian blur passes for the color buffer.";
> = 1.6f;

uniform float _P <
    ui_category_closed = true;
    ui_category = "Difference Of Gaussians Settings";
    ui_min = 0.0f; ui_max = 100.0f;
    ui_label = "Sharpness";
    ui_type = "slider";
    ui_tooltip = "Adjust sharpness of the two gaussian blurs to bring out edge lines.";
> = 1.0f;

uniform bool _SmoothEdges <
    ui_label = "Smooth Edges";
    ui_tooltip = "Whether or not to apply anti aliasing to the edges of the image.";
> = true;

uniform float _SigmaA <
    ui_category_closed = true;
    ui_category = "Anti Aliasing Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Edge Smooth Deviation";
    ui_type = "slider";
    ui_tooltip = "Adjust standard deviation for gaussian blurring of edge lines.";
> = 2.0f;

uniform float2 _AntiAliasStepSize <
    ui_category_closed = true;
    ui_category = "Anti Aliasing Settings";
    ui_label = "Edge Smoothing Step Sizes";
    ui_type = "drag";
    ui_tooltip = "Increase distance between smoothing samples for more painterly visuals.";
> = 1.0f;


uniform int _Thresholding <
    ui_category_closed = true;
    ui_category = "Threshold Settings";
    ui_type = "combo";
    ui_label = "Threshold Mode";
    ui_items = "No Threshold\0"
               "Tanh\0"
               "Quantization\0"
               "Soft Quantization\0";
> = 0;

uniform int _Thresholds <
    ui_category_closed = true;
    ui_category = "Threshold Settings";
    ui_min = 1; ui_max = 16;
    ui_label = "Quantizer Step";
    ui_type = "slider";
    ui_tooltip = "Adjust number of allowed difference values.";
> = 1;

uniform float _Threshold <
    ui_category_closed = true;
    ui_category = "Threshold Settings";
    ui_min = 0.0f; ui_max = 100.0f;
    ui_label = "White Point";
    ui_type = "slider";
    ui_tooltip = "Adjust value at which difference is clamped to white.";
> = 20.0f;

uniform float _Phi <
    ui_category_closed = true;
    ui_category = "Threshold Settings";
    ui_min = 0.0f; ui_max = 10.0f;
    ui_label = "Soft Threshold";
    ui_type = "slider";
    ui_tooltip = "Adjust curve of hyperbolic tangent.";
> = 1.0f;

uniform float _TermStrength <
    ui_category_closed = true;
    ui_category = "Blend Settings";
    ui_min = 0.0f; ui_max = 5.0f;
    ui_label = "Term Strength";
    ui_type = "drag";
    ui_tooltip = "Adjust scale of difference of gaussians output.";
> = 1;

uniform int _BlendMode <
    ui_category_closed = true;
    ui_category = "Blend Settings";
    ui_type = "combo";
    ui_label = "Blend Mode";
    ui_items = "No Blend\0"
               "Interpolate\0"
               "Two Point Interpolate\0";
> = 0;

uniform float3 _MinColor <
    ui_category_closed = true;
    ui_category = "Blend Settings";
    ui_min = 0.0f; ui_max = 1.0f;
    ui_label = "Min Color";
    ui_type = "color";
    ui_tooltip = "Set minimum color.";
> = 0.0f;

uniform float3 _MaxColor <
    ui_category_closed = true;
    ui_category = "Blend Settings";
    ui_min = 0.0f; ui_max = 1.0f;
    ui_label = "Max Color";
    ui_type = "color";
    ui_tooltip = "Set maximum color.";
> = 1.0f;

uniform float _BlendStrength <
    ui_category_closed = true;
    ui_category = "Blend Settings";
    ui_min = 0.0f; ui_max = 1.0f;
    ui_label = "Blend Strength";
    ui_type = "drag";
    ui_tooltip = "Adjust strength of color blending.";
> = 1;

texture2D AFX_HorizontalBlurTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 
sampler2D HorizontalBlur { Texture = AFX_HorizontalBlurTex; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; };
storage2D s_HorizontalBlur { Texture = AFX_HorizontalBlurTex; };
texture2D AFX_DOGTFMTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 
sampler2D DOGTFM { Texture = AFX_DOGTFMTex; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; };
storage2D s_DOGTFM { Texture = AFX_DOGTFMTex; };
texture2D AFX_DifferenceOfGaussiansTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 
sampler2D DifferenceOfGaussians { Texture = AFX_DifferenceOfGaussiansTex; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; };
storage2D s_DifferenceOfGaussians { Texture = AFX_DifferenceOfGaussiansTex; };
texture2D AFX_LabTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; }; 
sampler2D Lab { Texture = AFX_LabTex; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; };
texture2D AFX_GaussiansBlendedTex < pooled = true; > { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA16F; };
sampler2D GaussiansBlended { Texture = AFX_GaussiansBlendedTex; MagFilter = POINT; MinFilter = POINT; MipFilter = POINT; };
storage2D s_GaussiansBlended { Texture = AFX_GaussiansBlendedTex; };
float4 PS_EndPass(float4 position : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET { return tex2D(GaussiansBlended, uv).rgba; }

float gaussian(float sigma, float pos) {
    return (1.0f / sqrt(2.0f * AFX_PI * sigma * sigma)) * exp(-(pos * pos) / (2.0f * sigma * sigma));
}

float4 PS_RGBtoLAB(float4 position : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET {
    return float4(Common::rgb2lab(saturate(tex2D(Common::AcerolaBuffer, uv).rgb)), 1.0f);
}

void CS_StructureTensor(uint3 tid : SV_DISPATCHTHREADID) {
    float2 d = float2(1, 1);

    float3 Sx = (
            1.0f * tex2Dfetch(Lab, tid.xy + float2(-d.x, -d.y)).rgb +
            2.0f * tex2Dfetch(Lab, tid.xy + float2(-d.x,  0.0)).rgb +
            1.0f * tex2Dfetch(Lab, tid.xy + float2(-d.x,  d.y)).rgb +
            -1.0f * tex2Dfetch(Lab, tid.xy + float2(d.x, -d.y)).rgb +
            -2.0f * tex2Dfetch(Lab, tid.xy + float2(d.x,  0.0)).rgb +
            -1.0f * tex2Dfetch(Lab, tid.xy + float2(d.x,  d.y)).rgb
    ) / 4.0f;

    float3 Sy = (
            1.0f * tex2Dfetch(Lab, tid.xy + float2(-d.x, -d.y)).rgb +
            2.0f * tex2Dfetch(Lab, tid.xy + float2( 0.0, -d.y)).rgb +
            1.0f * tex2Dfetch(Lab, tid.xy + float2( d.x, -d.y)).rgb +
            -1.0f * tex2Dfetch(Lab, tid.xy + float2(-d.x, d.y)).rgb +
            -2.0f * tex2Dfetch(Lab, tid.xy + float2( 0.0, d.y)).rgb +
            -1.0f * tex2Dfetch(Lab, tid.xy + float2( d.x, d.y)).rgb
    ) / 4.0f;

    tex2Dstore(s_DifferenceOfGaussians, tid.xy, float4(dot(Sx, Sx), dot(Sy, Sy), dot(Sx, Sy), 1.0f));
}

void CS_TFMHorizontalBlur(uint3 tid : SV_DISPATCHTHREADID) {
    int kernelRadius = max(1.0f, floor(_SigmaC * 2.45f));

    float3 col = 0;
    float kernelSum = 0.0f;

    for (int x = -kernelRadius; x <= kernelRadius; ++x) {
        float3 c = tex2Dfetch(DifferenceOfGaussians, tid.xy + float2(x, 0)).rgb;
        float gauss = gaussian(_SigmaC, x);

        col += c * gauss;
        kernelSum += gauss;
    }

    tex2Dstore(s_HorizontalBlur, tid.xy, float4(col / kernelSum, 1.0f));
}

void CS_TFMVerticalBlur(uint3 tid : SV_DISPATCHTHREADID) {
    int kernelRadius = max(1.0f, floor(_SigmaC * 2.45f));

    float3 col = 0;
    float kernelSum = 0.0f;

    for (int y = -kernelRadius; y <= kernelRadius; ++y) {
        float3 c = tex2Dfetch(HorizontalBlur, tid.xy + float2(0, y)).rgb;
        float gauss = gaussian(_SigmaC, y);

        col += c * gauss;
        kernelSum += gauss;
    }

    float3 g = col.rgb / kernelSum;

    float lambda1 = 0.5f * (g.y + g.x + sqrt(g.y * g.y - 2.0f * g.x * g.y + g.x * g.x + 4.0 * g.z * g.z));
    float2 d = float2(g.x - lambda1, g.z);

    tex2Dstore(s_DOGTFM, tid.xy, length(d) ? float4(normalize(d), sqrt(lambda1), 1.0f) : float4(0.0f, 1.0f, 0.0f, 1.0f));
}

void CS_HorizontalBlur(uint3 tid : SV_DISPATCHTHREADID) {
    int kernelRadius = _SigmaE * 2 > 1 ? _SigmaE * 2 : 1;

    if (_UseFlow) {
        float2 t = tex2Dfetch(DOGTFM, tid.xy).xy;
        float2 n = float2(t.y, -t.x);
        float2 nabs = abs(n);
        float ds = 1.0 / ((nabs.x > nabs.y) ? nabs.x : nabs.y);

        float2 col = tex2Dfetch(Lab, tid.xy).xx;
        float2 kernelSum = 1.0f;

        [loop]
        for (int x = 1; x <= kernelRadius; ++x) {
            float gauss1 = gaussian(_SigmaE, x);
            float gauss2 = gaussian(_SigmaE * _K, x);

            float c1 = tex2Dfetch(Lab, tid.xy - x * n).r;
            float c2 = tex2Dfetch(Lab, tid.xy + x * n).r;

            col.r += (c1 + c2) * gauss1;
            kernelSum.x += 2.0f * gauss1;

            col.g += (c1 + c2) * gauss2;
            kernelSum.y += 2.0f * gauss2;
        }

        col /= kernelSum;

        tex2Dstore(s_HorizontalBlur, tid.xy, float4(col, (1 + _P) * (col.r * 100.0f) - _P * (col.g * 100.0f), 1.0f));
    } else { // Normal DoG Blur Pass    
        float2 col = 0;
        float2 kernelSum = 0.0f;

        for (int x = -kernelRadius; x <= kernelRadius; ++x) {
            float c = tex2Dfetch(Lab, tid.xy + float2(x, 0)).r;
            float gauss1 = gaussian(_SigmaE, x);
            float gauss2 = gaussian(_SigmaE * _K, x);

            col.r += c * gauss1;
            kernelSum.r += gauss1;

            col.g += c * gauss2;
            kernelSum.g += gauss2;
        }

        tex2Dstore(s_HorizontalBlur, tid.xy, float4(col / kernelSum, 1.0f, 1.0f));
    }
}

float4 PS_VerticalBlur(float4 position : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET {
    int kernelRadius = _SigmaE * 2 > 1 ? _SigmaE * 2 : 1;
    float D = 0.0f;
    float2 texelSize = float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT);

    if (_UseFlow) {
        kernelRadius = _SigmaM * 2 > 1 ? _SigmaM * 2 : 1;

        float2 G = 0.0f;
        float2 w = 0.0f;

        float2 v = tex2D(DOGTFM, uv).xy * texelSize;
        float2 stepSize = _LineIntegralStepSize;

        float2 st0 = uv;
        float2 v0 = v;

        [loop]
        for (int d = 0; d < kernelRadius; ++d) {
            st0 += v0 * stepSize.x;
            float3 c = tex2D(HorizontalBlur, st0).rgb;
            float gauss1 = gaussian(_SigmaM, d);


            if (_CalcDiffBeforeConvolving) {
                G.r += gauss1 * c.b;
                w.x += gauss1;
            } else {
                float gauss2 = gaussian(_SigmaM * _K, d);

                G.r += gauss1 * c.r;
                w.x += gauss1;

                G.g += gauss2 * c.g;
                w.y += gauss2;
            }

            v0 = tex2D(DOGTFM, st0).xy * texelSize;
        }

        float2 st1 = uv;
        float2 v1 = v;

        [loop]
        for (int d = 0; d < kernelRadius; ++d) {
            st1 -= v1 * stepSize.y;
            float3 c = tex2D(HorizontalBlur, st1).rgb;
            float gauss1 = gaussian(_SigmaM, d);


            if (_CalcDiffBeforeConvolving) {
                G.r += gauss1 * c.b;
                w.x += gauss1;
            } else {
                float gauss2 = gaussian(_SigmaM * _K, d);

                G.r += gauss1 * c.r;
                w.x += gauss1;

                G.g += gauss2 * c.g;
                w.y += gauss2;
            }

            v1 = tex2D(DOGTFM, st1).xy * texelSize;
        }

        G /= max(0.000001f, w);

        if (_CalcDiffBeforeConvolving) {
            D = G.x;
        } else {
            D = (1 + _P) * (G.r * 100.0f) - _P * (G.g * 100.0f);
        }
    } else {
        float2 col = 0;
        float2 kernelSum = 0.0f;

        for (int y = -kernelRadius; y <= kernelRadius; ++y) {
            float c = tex2D(HorizontalBlur, uv + float2(0, y) * float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)).r;
            float gauss1 = gaussian(_SigmaE, y);
            float gauss2 = gaussian(_SigmaE * _K, y);

            col.r += c * gauss1;
            kernelSum.r += gauss1;
            
            col.g += c * gauss2;
            kernelSum.g += gauss2;
        }

        D = (1 + _P) * (col.r * 100.0f) - _P * (col.g * 100.0f);
    }
    D = max(0.0f, D);

    float4 output = D;
    if (_Thresholding == 0)
        output /= 100.0f;
    if (_Thresholding == 1)
        output = (D >= _Threshold) ? 1 : 1 + tanh(_Phi * (D - _Threshold));
    if (_Thresholding == 2) {
        float a = 1.0f / _Thresholds;
        float b = _Threshold / 100.0f;
        float x = D / 100.0f;

        output = (x >= b) ? 1 : a * floor((pow(abs(x), _Phi) - (a * b / 2.0f)) / (a * b) + 0.5f);
    }
    if (_Thresholding == 3) {
        float x = D / 100.0f;
        float qn = floor(x * float(_Thresholds) + 0.5f) / float(_Thresholds);
        float qs = smoothstep(-2.0, 2.0, _Phi * (x - qn) * 10.0f) - 0.5f;
        
        output = qn + qs / float(_Thresholds);
    }

    return saturate(output);
}

float4 PS_AntiAlias(float4 position : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET {
    if (_SmoothEdges) {
        float2 texelSize = float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT);
        
        float kernelSize = _SigmaA * 2;

        float3 G = 0.0f;
        float w = 0.0f;

        float2 v = tex2D(DOGTFM, uv).xy * texelSize;
        float2 stepSize = _AntiAliasStepSize;

        float2 st0 = uv;
        float2 v0 = v;

        [loop]
        for (int d = 0; d < kernelSize; ++d) {
            st0 += v0 * stepSize.x;
            float3 c = tex2D(DifferenceOfGaussians, st0).rgb;
            float gauss1 = gaussian(_SigmaA, d);

            G += gauss1 * c;
            w += gauss1;

            v0 = tex2D(DOGTFM, uv).xy * texelSize;
        }

        float2 st1 = uv;
        float2 v1 = v;

        [loop]
        for (int d = 0; d < kernelSize; ++d) {
            st1 -= v1 * stepSize.y;
            float3 c = tex2D(DifferenceOfGaussians, st1).rgb;
            float gauss1 = gaussian(_SigmaA, d);

            G += gauss1 * c;
            w += gauss1;

            v1 = tex2D(DOGTFM, uv).xy * texelSize;
        }

        return float4(G /= w, 1.0f);
    } else {
        return tex2D(DifferenceOfGaussians, uv);
    }
}

void CS_ColorBlend(uint3 tid : SV_DISPATCHTHREADID) {
    float4 col = tex2Dfetch(Common::AcerolaBuffer, tid.xy);
    float D = tex2Dfetch(HorizontalBlur, tid.xy).r * _TermStrength;

    float4 output = 1.0f;
    if (_BlendMode == 0)
        output.rgb = lerp(_MinColor, _MaxColor, D);
    if (_BlendMode == 1)
        output.rgb = lerp(_MinColor, col.rgb, D);
    if (_BlendMode == 2) {
        if (D.r < 0.5f)
            output.rgb = lerp(_MinColor, col.rgb, D * 2.0f);
        else
            output.rgb = lerp(col.rgb, _MaxColor, (D - 0.5f) * 2.0f);
    }

    tex2Dstore(s_GaussiansBlended, tid.xy, saturate(lerp(col, output, _BlendStrength)));
}

technique AFX_DifferenceOfGaussians < ui_label = "Difference Of Gaussians"; > {
    pass {
        RenderTarget = AFX_LabTex;

        VertexShader = PostProcessVS;
        PixelShader = PS_RGBtoLAB;
    }

    pass {
        ComputeShader = CS_StructureTensor<8, 8>;

        DispatchSizeX = (BUFFER_WIDTH + 7) / 8;
        DispatchSizeY = (BUFFER_HEIGHT + 7) / 8;
    }

    pass {
        ComputeShader = CS_TFMHorizontalBlur<8, 8>;

        DispatchSizeX = (BUFFER_WIDTH + 7) / 8;
        DispatchSizeY = (BUFFER_HEIGHT + 7) / 8;
    }

    pass {
        ComputeShader = CS_TFMVerticalBlur<8, 8>;

        DispatchSizeX = (BUFFER_WIDTH + 7) / 8;
        DispatchSizeY = (BUFFER_HEIGHT + 7) / 8;
    }

    pass {
        ComputeShader = CS_HorizontalBlur<8, 8>;

        DispatchSizeX = (BUFFER_WIDTH + 7) / 8;
        DispatchSizeY = (BUFFER_HEIGHT + 7) / 8;
    }

    pass {
        RenderTarget = AFX_DifferenceOfGaussiansTex;

        VertexShader = PostProcessVS;
        PixelShader = PS_VerticalBlur;
    }

    pass {
        RenderTarget = AFX_HorizontalBlurTex;

        VertexShader = PostProcessVS;
        PixelShader = PS_AntiAlias;
    }

    pass {
        ComputeShader = CS_ColorBlend<8, 8>;

        DispatchSizeX = (BUFFER_WIDTH + 7) / 8;
        DispatchSizeY = (BUFFER_HEIGHT + 7) / 8;
    }


    pass EndPass {
        RenderTarget = Common::AcerolaBufferTex;

        VertexShader = PostProcessVS;
        PixelShader = PS_EndPass;
    }
}