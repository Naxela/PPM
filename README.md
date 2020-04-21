![](img/wip_notice.jpg)

# NOTE DEPRECATED!
This addon has now been implemented into Armory. You can find the nodes under the "Postprocess category". Enable it under the Renderpath by toggling "Realtime Postprocess".

## Post-Processing Module
Post-Processing Module (Formerly Post-Processing Volumes) is an addon for Armory3D that implements realtime colorgrading and implements both existing and new shaders as uniforms that can be fully controlled both through Haxe and through Logic Nodes.

## Version 0.3 [Download: https://github.com/Naxela/PPM/archive/0.3.zip]:
- Version 0.3 updates to PPM to support Armory version 2019.6 and adds support for more effects. An expanded selection of camera effects and lighting controls have been added, as well controls for Depth of Field and Film Grain. Additionally, controls have been added for the following effects:

![](img/PPM03A.gif)

This update also includes additional new screen-effects/filters, such as Chromatic Aberration (also known as Scene fringe) as well as and lens dirt/luminance masking. Finally, there's an additional option to select custom tonemapping controls.

![](img/PPM03B.gif)

Overall there's 14 new nodes:

![](img/nodes3.png)

## Version 0.2 [Download: https://github.com/Naxela/PPM/archive/0.2.zip]:
- Version 0.2 continues to improve the colorgrading and add more nodes. The colorgrading nodes have been organized in Get and Set nodes for easier data application and retrieval. The first auxiliary node have been added in the form of a lerp float node, that allows for easier timed transitions. Version is compatible with Armory 0.6

![](img/nodes2.png)

## Version 0.1 [Download: https://github.com/Naxela/PPM/archive/0.1.zip]:
- Version 0.1 is the first version after refactoring, that implements fully working colorgrading for all luminance intensities, as well as per color channel selection. I intend to be more structured with this addon than I was earlier, as such a lot of realtime uniforms and shaders have been removed temporarily. They will be added gradually. For the old code, please refer to the commit history caches. Version is compatible with Armory 0.6

![](img/nodes.png)

A selection of the currently available nodes.

## Why as an addon?
I'd rather not commit something to Armory that is still bugged, incomplete and not as optimized as possible. Still lots of things to do to make it useful. This is compatible with the Armory 0.6 version - This addon might break Armory. Bugs should be reported on this github section rather than the main Armory repo.

## How to - Installation

Get the latest release from the release section here on Github: https://github.com/Naxela/PPM/archive/0.2.zip

Simply copy and paste the **armsdk** folder directly into your Armory/Blender main folder and it will expose and implement the controls straight away. In order to include the uniforms and include the shader code, toggle on "PPM" in the renderpath.

## How to - With Logic Nodes

- Open up blender, make a quick scene
- Add a new renderpath, and make sure to toggle "PPM" under Armory Render Path > Renderer
- Create a new node tree and attach it to your objects
- Add the colorgrading node you want (Colograding Global for example)
- Attach an event or input node (On Init for example) and plug it in
- Adjust your settings for the PPM node to your liking
- Press F5 to run. Simple as that.

## How to - With Haxe
- Open up blender, make a quick scene
- Add a new renderpath, and make sure to toggle "PPM" under Armory Render Path > Renderer

The PPM uniform values are directly accessible as public arrays inside the PPM.hx file. For instance, if you want to change the global contrast uniform, it is accessible from the **colorgrading_global_uniforms** array. A simple haxe script
example of changing this would look like this:

```haxe
package arm;

class PPM_Test extends iron.Trait {
	public function new() {
		super();

		 notifyOnInit(function() {
			 armory.renderpath.PPM.colorgrading_global_uniforms[3][0] = 2.0;
			 armory.renderpath.PPM.colorgrading_global_uniforms[3][1] = 0.5;
			 armory.renderpath.PPM.colorgrading_global_uniforms[3][2] = 0.0;
		 });

	}
}
```

The result of the above would leave you with frame that has an red-orangey hue to it, due to the red channel being most prominent. The contrast vector is the third [3] array element, with the subsequent 0,1,2 array keys indicating the Red [0], Green [1] and Blue [2] color channels. For a full list of the uniforms and their corresponding keys, please refer to the PPM.hx file - The keys and uniforms are commented in the file.


## Future plans:
- Library version: Add a drag&drop library version of this.
- Add auxiliary helper nodes: Organize in Get/Set nodes, add transition nodes, PPM blending nodes and possibly more.
- More documentation: Pretty self-explanatory.
- More examples: Will make a separate repo at some point.
- More uniforms: Gradually add uniforms for SSR, Bloom, AO, VXGI, Compositor Effects, SH/Env/Indirect and more.
- More shaders: I have a couple of WIP shaders, such as chromatic aberration, HQ Bloom, Preetham Sky, Dirt Lens that I am still working on. Should come along with time.


Example from some of the possible effects (screencap from early WIP version):

![](img/PPV.gif)
=======
