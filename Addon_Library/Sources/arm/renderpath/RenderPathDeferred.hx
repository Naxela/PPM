package arm.renderpath;

import iron.RenderPath;

class RenderPathDeferred {

	#if (rp_renderer == "Deferred")

	static var path:RenderPath;

	#if (rp_gi != "Off")
	static var voxels = "voxels";
	static var voxelsLast = "voxels";
	#end

	public static function drawMeshes() {
		path.drawMeshes("mesh");
	}

	public static function applyConfig() {
		Inc.applyConfig();
	}

	public static function init(_path:RenderPath) {

		path = _path;

		// #if (rp_shadowmap && kha_webgl)
		// Inc.initEmpty();
		// #end

		#if (rp_background == "World")
		{
			path.loadShader("shader_datas/world_pass/world_pass");
		}
		#end

		#if (rp_translucency)
		{
			Inc.initTranslucency();
		}
		#end

		#if (rp_gi != "Off")
		{
			Inc.initGI();
			#if arm_voxelgi_temporal
			{
				Inc.initGI("voxelsB");
			}
			#end
			#if (rp_gi == "Voxel GI")
			{
				// Inc.initGI("voxelsOpac");
				// Inc.initGI("voxelsNor");
				// #if (rp_gi_bounces)
				// Inc.initGI("voxelsBounce");
				// #end
			}
			#end
			#if (rp_gi == "Voxel AO")
			path.loadShader("shader_datas/deferred_light/deferred_light_VoxelAOvar");
			#end
		}
		#end

		{
			path.createDepthBuffer("main", "DEPTH24");

			var t = new RenderTargetRaw();
			t.name = "gbuffer0";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA64";
			t.scale = Inc.getSuperSampling();
			t.depth_buffer = "main";
			path.createRenderTarget(t);
		}

		{
			var t = new RenderTargetRaw();
			t.name = "tex";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = Inc.getHdrFormat();
			t.scale = Inc.getSuperSampling();
			t.depth_buffer = "main";
			#if rp_autoexposure
			t.mipmaps = true;
			#end
			path.createRenderTarget(t);
			#if rp_autoexposure
			// Texture lod is fetched manually, prevent mipmap filtering
			t.mipmaps = false;
			#end
		}

		{
			var t = new RenderTargetRaw();
			t.name = "buf";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = Inc.getHdrFormat();
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}

		{
			var t = new RenderTargetRaw();
			t.name = "gbuffer1";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA64";
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}

		#if rp_gbuffer2
		{
			var t = new RenderTargetRaw();
			t.name = "gbuffer2";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA64";
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}

		{
			var t = new RenderTargetRaw();
			t.name = "taa";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA32";
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}
		#end

		#if rp_material_solid
		path.loadShader("shader_datas/deferred_light_solid/deferred_light");
		#elseif rp_material_mobile
		path.loadShader("shader_datas/deferred_light_mobile/deferred_light");
		#else
		path.loadShader("shader_datas/deferred_light/deferred_light");
		#end

		#if rp_probes
		path.loadShader("shader_datas/probe_planar/probe_planar");
		path.loadShader("shader_datas/probe_cubemap/probe_cubemap");
		path.loadShader("shader_datas/copy_pass/copy_pass");
		#end

		#if ((rp_ssgi == "RTGI") || (rp_ssgi == "RTAO"))
		{
			path.loadShader("shader_datas/ssgi_pass/ssgi_pass");
			path.loadShader("shader_datas/blur_edge_pass/blur_edge_pass_x");
			path.loadShader("shader_datas/blur_edge_pass/blur_edge_pass_y");
		}
		#elseif (rp_ssgi == "SSAO")
		{
			path.loadShader("shader_datas/ssao_pass/ssao_pass");
			path.loadShader("shader_datas/blur_edge_pass/blur_edge_pass_x");
			path.loadShader("shader_datas/blur_edge_pass/blur_edge_pass_y");
		}
		#end

		#if ((rp_ssgi != "Off") || rp_volumetriclight)
		{
			var t = new RenderTargetRaw();
			t.name = "singlea";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "R8";
			t.scale = Inc.getSuperSampling();
			#if rp_ssgi_half
			t.scale *= 0.5;
			#end
			path.createRenderTarget(t);
		}
		{
			var t = new RenderTargetRaw();
			t.name = "singleb";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "R8";
			t.scale = Inc.getSuperSampling();
			#if rp_ssgi_half
			t.scale *= 0.5;
			#end
			path.createRenderTarget(t);
		}
		#end

		#if ((rp_antialiasing == "SMAA") || (rp_antialiasing == "TAA"))
		{
			var t = new RenderTargetRaw();
			t.name = "bufa";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA32";
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}
		{
			var t = new RenderTargetRaw();
			t.name = "bufb";
			t.width = 0;
			t.height = 0;
			t.displayp = Inc.getDisplayp();
			t.format = "RGBA32";
			t.scale = Inc.getSuperSampling();
			path.createRenderTarget(t);
		}
		#end

		#if rp_compositornodes
		{
			path.loadShader("shader_datas/compositor_pass/compositor_pass");
		}
		#end

		path.loadShader("colorgrading_pass/colorgrading_pass/colorgrading_pass");
		path.loadShader("shader_datas/copy_pass/copy_pass");

		#if ((!rp_compositornodes) || (rp_antialiasing == "TAA") || (rp_motionblur == "Camera") || (rp_motionblur == "Object"))
		{
			path.loadShader("shader_datas/copy_pass/copy_pass");
		}
		#end

		#if ((rp_antialiasing == "SMAA") || (rp_antialiasing == "TAA"))
		{
			path.loadShader("shader_datas/smaa_edge_detect/smaa_edge_detect");
			path.loadShader("shader_datas/smaa_blend_weight/smaa_blend_weight");
			path.loadShader("shader_datas/smaa_neighborhood_blend/smaa_neighborhood_blend");

			#if (rp_antialiasing == "TAA")
			{
				path.loadShader("shader_datas/taa_pass/taa_pass");
			}
			#end
		}
		#end

		#if (rp_supersampling == 4)
		{
			path.loadShader("shader_datas/supersample_resolve/supersample_resolve");
		}
		#end

		#if rp_volumetriclight
		{
			path.loadShader("shader_datas/volumetric_light/volumetric_light");
			path.loadShader("shader_datas/blur_bilat_pass/blur_bilat_pass_x");
			path.loadShader("shader_datas/blur_bilat_blend_pass/blur_bilat_blend_pass_y");
		}
		#end

		#if rp_ocean
		{
			path.loadShader("shader_datas/water_pass/water_pass");
		}
		#end

		#if rp_bloom
		{
			var t = new RenderTargetRaw();
			t.name = "bloomtex";
			t.width = 0;
			t.height = 0;
			t.scale = 0.25;
			t.format = Inc.getHdrFormat();
			path.createRenderTarget(t);
		}

		{
			var t = new RenderTargetRaw();
			t.name = "bloomtex2";
			t.width = 0;
			t.height = 0;
			t.scale = 0.25;
			t.format = Inc.getHdrFormat();
			path.createRenderTarget(t);
		}

		{
			path.loadShader("shader_datas/bloom_pass/bloom_pass");
			path.loadShader("shader_datas/blur_gaus_pass/blur_gaus_pass_x");
			path.loadShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y");
			path.loadShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y_blend");
		}
		#end

		#if rp_sss
		{
			path.loadShader("shader_datas/sss_pass/sss_pass_x");
			path.loadShader("shader_datas/sss_pass/sss_pass_y");
		}
		#end

		#if (rp_ssr_half || rp_ssgi_half)
		{
			{
				path.loadShader("shader_datas/downsample_depth/downsample_depth");
				var t = new RenderTargetRaw();
				t.name = "half";
				t.width = 0;
				t.height = 0;
				t.scale = Inc.getSuperSampling() * 0.5;
				t.format = "R32"; // R16
				path.createRenderTarget(t);
			}
		}
		#end

		#if rp_ssr
		{
			path.loadShader("shader_datas/ssr_pass/ssr_pass");
			path.loadShader("shader_datas/blur_adaptive_pass/blur_adaptive_pass_x");
			path.loadShader("shader_datas/blur_adaptive_pass/blur_adaptive_pass_y3_blend");
			
			#if rp_ssr_half
			{
				var t = new RenderTargetRaw();
				t.name = "ssra";
				t.width = 0;
				t.height = 0;
				t.scale = Inc.getSuperSampling() * 0.5;
				t.format = Inc.getHdrFormat();
				path.createRenderTarget(t);
			}
			{
				var t = new RenderTargetRaw();
				t.name = "ssrb";
				t.width = 0;
				t.height = 0;
				t.scale = Inc.getSuperSampling() * 0.5;
				t.format = Inc.getHdrFormat();
				path.createRenderTarget(t);
			}
			#end
		}
		#end

		#if ((rp_motionblur == "Camera") || (rp_motionblur == "Object"))
		{
			#if (rp_motionblur == "Camera")
			{
				path.loadShader("shader_datas/motion_blur_pass/motion_blur_pass");
			}
			#else
			{
				path.loadShader("shader_datas/motion_blur_veloc_pass/motion_blur_veloc_pass");
			}
			#end
		}
		#end

		#if rp_soft_shadows
		{
			path.loadShader("shader_datas/dilate_pass/dilate_pass_x");
			path.loadShader("shader_datas/dilate_pass/dilate_pass_y");
			path.loadShader("shader_datas/visibility_pass/visibility_pass");
			path.loadShader("shader_datas/blur_shadow_pass/blur_shadow_pass_x");
			path.loadShader("shader_datas/blur_shadow_pass/blur_shadow_pass_y");
			{
				var t = new RenderTargetRaw();
				t.name = "visa";
				t.width = 0;
				t.height = 0;
				t.format = 'R16';
				path.createRenderTarget(t);
			}
			{
				var t = new RenderTargetRaw();
				t.name = "visb";
				t.width = 0;
				t.height = 0;
				t.format = 'R16';
				path.createRenderTarget(t);
			}
			{
				var t = new RenderTargetRaw();
				t.name = "dist";
				t.width = 0;
				t.height = 0;
				t.format = 'R16';
				path.createRenderTarget(t);
			}
		}
		#end

		#if arm_config
		{
			var t = new RenderTargetRaw();
			t.name = "empty_white";
			t.width = 1;
			t.height = 1;
			t.format = 'R8';
			var rt = new RenderTarget(t);
			var b = haxe.io.Bytes.alloc(1);
			b.set(0, 255);
			rt.image = kha.Image.fromBytes(b, t.width, t.height, kha.graphics4.TextureFormat.L8);
			path.renderTargets.set(t.name, rt);
		}
		#end
	}

	@:access(iron.RenderPath)
	public static function commands() {

		#if rp_dynres
		{
			DynamicResolutionScale.run(path);
		}
		#end

		path.setTarget("gbuffer0"); // Only clear gbuffer0
		#if (rp_background == "Clear")
		{
			path.clearTarget(-1, 1.0);
		}
		#else
		{
			path.clearTarget(null, 1.0);
		}
		#end

		#if rp_gbuffer2
		{
			path.setTarget("gbuffer2");
			path.clearTarget(0xff000000);
			path.setTarget("gbuffer0", ["gbuffer1", "gbuffer2"]);
		}
		#else
		{
			path.setTarget("gbuffer0", ["gbuffer1"]);
		}
		#end

		#if rp_stereo
		{
			path.drawStereo(drawMeshes);
		}
		#else
		{
			RenderPathCreator.drawMeshes();
		}
		#end

		#if rp_decals
		{
			path.setDepthFrom("gbuffer0", "gbuffer1"); // Unbind depth so we can read it
			path.depthToRenderTarget.set("main", path.renderTargets.get("tex"));
			
			path.setTarget("gbuffer0", ["gbuffer1"]);
			path.bindTarget("_main", "gbufferD");
			path.drawDecals("decal");
			
			path.setDepthFrom("gbuffer0", "tex"); // Re-bind depth
			path.depthToRenderTarget.set("main", path.renderTargets.get("gbuffer0"));
		}
		#end

		#if (rp_ssr_half || rp_ssgi_half)
		path.setTarget("half");
		path.bindTarget("_main", "texdepth");
		path.drawShader("shader_datas/downsample_depth/downsample_depth");
		#end

		#if ((rp_ssgi == "RTGI") || (rp_ssgi == "RTAO"))
		{
			if (armory.data.Config.raw.rp_ssgi != false) {
				path.setTarget("singlea");
				#if rp_ssgi_half
				path.bindTarget("half", "gbufferD");
				#else
				path.bindTarget("_main", "gbufferD");
				#end
				path.bindTarget("gbuffer0", "gbuffer0");
				// #if (rp_ssgi == "RTGI")
				// path.bindTarget("gbuffer1", "gbuffer1");
				// #end
				path.drawShader("shader_datas/ssgi_pass/ssgi_pass");

				path.setTarget("singleb");
				path.bindTarget("singlea", "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_edge_pass/blur_edge_pass_x");

				path.setTarget("singlea");
				path.bindTarget("singleb", "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_edge_pass/blur_edge_pass_y");
			}
		}	
		#elseif (rp_ssgi == "SSAO")
		{
			if (armory.data.Config.raw.rp_ssgi != false) {
				path.setTarget("singlea");
				path.bindTarget("_main", "gbufferD");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/ssao_pass/ssao_pass");

				path.setTarget("singleb");
				path.bindTarget("singlea", "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_edge_pass/blur_edge_pass_x");

				path.setTarget("singlea");
				path.bindTarget("singleb", "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_edge_pass/blur_edge_pass_y");
			}
		}
		#end

		#if (rp_shadowmap)
		Inc.drawShadowMap();
		#end

		// Voxels
		#if (rp_gi != "Off")
		if (armory.data.Config.raw.rp_gi != false)
		{
			var voxelize = path.voxelize();

			#if ((rp_gi == "Voxel GI") && (rp_voxelgi_relight))
			// Relight if light was moved
			for (light in iron.Scene.active.lights) {
				if (light.transform.diff()) { voxelize = true; break; }
			}
			#end

			#if arm_voxelgi_temporal
			voxelize = ++RenderPathCreator.voxelFrame % RenderPathCreator.voxelFreq == 0;

			if (voxelize) {
				voxels = voxels == "voxels" ? "voxelsB" : "voxels";
				voxelsLast = voxels == "voxels" ? "voxelsB" : "voxels";
			}
			#end

			if (voxelize) {
				var res = Inc.getVoxelRes();

				// #if (rp_gi == "Voxel GI")
				// var voxtex = "voxelsOpac";
				// #else
				var voxtex = voxels;
				// #end

				path.clearImage(voxtex, 0x00000000);
				path.setTarget("");
				path.setViewport(res, res);
				path.bindTarget(voxtex, "voxels");
				#if (rp_gi == "Voxel GI")
				// path.bindTarget("voxelsNor", "voxelsNor");
				for (l in iron.Scene.active.lights) {
					if (!l.visible || !l.data.raw.cast_shadow || l.data.raw.type != "sun") continue;
					var n = "shadowMap";
					path.bindTarget(n, n);
					break;
				}
				#end
				path.drawMeshes("voxel");
				path.generateMipmaps(voxels);
			}

			// if (relight) {
			// 	Inc.computeVoxelsBegin();
			// 	Inc.computeVoxels();
			// 	Inc.computeVoxelsEnd();
			// 	path.generateMipmaps(voxels);
			// }
		}
		#end

		// ---
		// Deferred light
		// ---
		path.setDepthFrom("tex", "gbuffer1"); // Unbind depth so we can read it
		path.setTarget("tex");
		path.bindTarget("_main", "gbufferD");
		path.bindTarget("gbuffer0", "gbuffer0");
		path.bindTarget("gbuffer1", "gbuffer1");
		#if (rp_ssgi != "Off")
		{
			if (armory.data.Config.raw.rp_ssgi != false) {
				path.bindTarget("singlea", "ssaotex");
			}
			else {
				path.bindTarget("empty_white", "ssaotex");
			}
		}
		#end
		var voxelao_pass = false;
		#if (rp_gi != "Off")
		if (armory.data.Config.raw.rp_gi != false)
		{
			#if (arm_config && (rp_gi == "Voxel AO"))
			voxelao_pass = true;
			#end
			path.bindTarget(voxels, "voxels");
			#if arm_voxelgi_temporal
			{
				path.bindTarget(voxelsLast, "voxelsLast");
			}
			#end
		}
		#end

		#if rp_shadowmap
		{
			#if rp_soft_shadows
			path.bindTarget("visa", "svisibility");
			#else
			Inc.bindShadowMap();
			#end
		}
		#end
		
		#if rp_material_solid
		path.drawShader("shader_datas/deferred_light_solid/deferred_light");
		#elseif rp_material_mobile
		path.drawShader("shader_datas/deferred_light_mobile/deferred_light");
		#else
		voxelao_pass ?
			path.drawShader("shader_datas/deferred_light/deferred_light_VoxelAOvar") :
			path.drawShader("shader_datas/deferred_light/deferred_light");
		#end

		#if rp_probes
		if (!path.isProbe) {
			var probes = iron.Scene.active.probes;
			for (i in 0...probes.length) {
				var p = probes[i];
				if (!p.visible || p.culled) continue;
				path.currentProbeIndex = i;
				path.setTarget("tex");
				path.bindTarget("_main", "gbufferD");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.bindTarget("gbuffer1", "gbuffer1");
				path.bindTarget(p.raw.name, "probeTex");
				if (p.data.raw.type == "planar") {
					path.drawVolume(p, "shader_datas/probe_planar/probe_planar");
				}
				else if (p.data.raw.type == "cubemap") {
					path.drawVolume(p, "shader_datas/probe_cubemap/probe_cubemap");
				}
			}
		}
		#end

		#if rp_ocean
		{
			path.setTarget("tex");
			path.bindTarget("_main", "gbufferD");
			path.drawShader("shader_datas/water_pass/water_pass");
		}
		#end

		#if rp_volumetriclight
		{
			path.setTarget("singlea");
			path.bindTarget("_main", "gbufferD");
			Inc.bindShadowMap();
			path.drawShader("shader_datas/volumetric_light/volumetric_light");

			path.setTarget("singleb");
			path.bindTarget("singlea", "tex");
			path.drawShader("shader_datas/blur_bilat_pass/blur_bilat_pass_x");

			path.setTarget("tex");
			path.bindTarget("singleb", "tex");
			path.drawShader("shader_datas/blur_bilat_blend_pass/blur_bilat_blend_pass_y");
		}
		#end

		path.setDepthFrom("tex", "gbuffer0"); // Re-bind depth

		#if (rp_background == "World")
		{
			path.setTarget("tex"); // Re-binds depth
			path.drawSkydome("shader_datas/world_pass/world_pass");
		}
		#end

		#if rp_blending
		{
			path.drawMeshes("blend");
		}
		#end

		#if rp_translucency
		{
			var hasLight = iron.Scene.active.lights.length > 0;
			if (hasLight) Inc.drawTranslucency("tex");
		}
		#end

		#if rp_bloom
		{
			if (armory.data.Config.raw.rp_bloom != false) {
				path.setTarget("bloomtex");
				path.bindTarget("tex", "tex");
				path.drawShader("shader_datas/bloom_pass/bloom_pass");

				path.setTarget("bloomtex2");
				path.bindTarget("bloomtex", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_x");

				path.setTarget("bloomtex");
				path.bindTarget("bloomtex2", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y");

				path.setTarget("bloomtex2");
				path.bindTarget("bloomtex", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_x");

				path.setTarget("bloomtex");
				path.bindTarget("bloomtex2", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y");

				path.setTarget("bloomtex2");
				path.bindTarget("bloomtex", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_x");

				path.setTarget("bloomtex");
				path.bindTarget("bloomtex2", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y");

				path.setTarget("bloomtex2");
				path.bindTarget("bloomtex", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_x");

				path.setTarget("tex");
				path.bindTarget("bloomtex2", "tex");
				path.drawShader("shader_datas/blur_gaus_pass/blur_gaus_pass_y_blend");
			}
		}
		#end

		#if rp_sss
		{
			path.setTarget("buf");
			path.bindTarget("tex", "tex");
			path.bindTarget("_main", "gbufferD");
			path.bindTarget("gbuffer0", "gbuffer0");
			path.drawShader("shader_datas/sss_pass/sss_pass_x");

			path.setTarget("tex");
			path.bindTarget("buf", "tex");
			path.bindTarget("_main", "gbufferD");
			path.bindTarget("gbuffer0", "gbuffer0");
			path.drawShader("shader_datas/sss_pass/sss_pass_y");
		}
		#end

		#if rp_ssr
		{
			if (armory.data.Config.raw.rp_ssr != false) {
				#if rp_ssr_half
				var targeta = "ssra";
				var targetb = "ssrb";
				#else
				var targeta = "buf";
				var targetb = "gbuffer1";
				#end

				path.setTarget(targeta);
				path.bindTarget("tex", "tex");
				#if rp_ssr_half
				path.bindTarget("half", "gbufferD");
				#else
				path.bindTarget("_main", "gbufferD");
				#end
				path.bindTarget("gbuffer0", "gbuffer0");
				path.bindTarget("gbuffer1", "gbuffer1");
				path.drawShader("shader_datas/ssr_pass/ssr_pass");

				path.setTarget(targetb);
				path.bindTarget(targeta, "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_adaptive_pass/blur_adaptive_pass_x");

				path.setTarget("tex");
				path.bindTarget(targetb, "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				path.drawShader("shader_datas/blur_adaptive_pass/blur_adaptive_pass_y3_blend");
			}
		}
		#end

		#if ((rp_motionblur == "Camera") || (rp_motionblur == "Object"))
		{
			if (armory.data.Config.raw.rp_motionblur != false) {
				path.setTarget("buf");
				path.bindTarget("tex", "tex");
				path.bindTarget("gbuffer0", "gbuffer0");
				#if (rp_motionblur == "Camera")
				{
					path.bindTarget("_main", "gbufferD");
					path.drawShader("shader_datas/motion_blur_pass/motion_blur_pass");
				}
				#else
				{
					path.bindTarget("gbuffer2", "sveloc");
					path.drawShader("shader_datas/motion_blur_veloc_pass/motion_blur_veloc_pass");
				}
				#end
				path.setTarget("tex");
				path.bindTarget("buf", "tex");
				path.drawShader("shader_datas/copy_pass/copy_pass");
			}
		}
		#end

		// We are just about to enter compositing, add more custom passes here
		// #if rp_custom_pass
		// {
		path.setTarget("buf");
		path.bindTarget("tex","tex");
		path.drawShader("colorgrading_pass/colorgrading_pass/colorgrading_pass");
		path.setTarget("tex");
		path.bindTarget("buf","tex");
		path.drawShader("shader_datas/copy_pass/copy_pass");
		// }
		// #end

		// Begin compositor
		#if rp_autoexposure
		{
			path.generateMipmaps("tex");
		}
		#end

		#if (rp_supersampling == 4)
		var framebuffer = "buf";
		#else
		var framebuffer = "";
		#end

		#if ((rp_antialiasing == "Off") || (rp_antialiasing == "FXAA") || (!rp_render_to_texture))
		{
			RenderPathCreator.finalTarget = path.currentTarget;
			path.setTarget(framebuffer);
		}
		#else
		{
			RenderPathCreator.finalTarget = path.currentTarget;
			path.setTarget("buf");
		}
		#end
		
		path.bindTarget("tex", "tex");
		#if rp_compositordepth
		{
			path.bindTarget("_main", "gbufferD");
		}
		#end

		#if rp_compositornodes
		{
			if (!path.isProbe) path.drawShader("shader_datas/compositor_pass/compositor_pass");
			else path.drawShader("shader_datas/copy_pass/copy_pass");
		}
		#else
		{
			path.drawShader("shader_datas/copy_pass/copy_pass");
		}
		#end
		// End compositor

		#if rp_overlays
		{
			path.clearTarget(null, 1.0);
			path.drawMeshes("overlay");
		}
		#end

		#if ((rp_antialiasing == "SMAA") || (rp_antialiasing == "TAA"))
		{
			path.setTarget("bufa");
			path.clearTarget(0x00000000);
			path.bindTarget("buf", "colorTex");
			path.drawShader("shader_datas/smaa_edge_detect/smaa_edge_detect");

			path.setTarget("bufb");
			path.clearTarget(0x00000000);
			path.bindTarget("bufa", "edgesTex");
			path.drawShader("shader_datas/smaa_blend_weight/smaa_blend_weight");

			#if (rp_antialiasing == "TAA")
			path.isProbe ? path.setTarget(framebuffer) : path.setTarget("bufa");
			#else
			path.setTarget(framebuffer);
			#end
			path.bindTarget("buf", "colorTex");
			path.bindTarget("bufb", "blendTex");
			#if (rp_antialiasing == "TAA")
			{
				path.bindTarget("gbuffer2", "sveloc");
			}
			#end
			path.drawShader("shader_datas/smaa_neighborhood_blend/smaa_neighborhood_blend");

			#if (rp_antialiasing == "TAA")
			{
				if (!path.isProbe) { // No last frame for probe
					path.setTarget(framebuffer);
					path.bindTarget("bufa", "tex");
					path.bindTarget("taa", "tex2");
					path.bindTarget("gbuffer2", "sveloc");
					path.drawShader("shader_datas/taa_pass/taa_pass");

					path.setTarget("taa");
					path.bindTarget("bufa", "tex");
					path.drawShader("shader_datas/copy_pass/copy_pass");
				}
			}
			#end
		}
		#end

		#if (rp_supersampling == 4)
		{
			var finalTarget = "";
			path.setTarget(finalTarget);
			path.bindTarget(framebuffer, "tex");
			path.drawShader("shader_datas/supersample_resolve/supersample_resolve");
		}
		#end
	}
	#end
}
