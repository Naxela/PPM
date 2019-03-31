package armory.logicnode;

class ColorgradingGetMidtoneNode extends LogicNode {

	public function new(tree:LogicTree) {
		super(tree);
	}

    override function get(from:Int):Dynamic {
        if(from == 0) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[0];
        } else if (from == 1) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[1];
        }  else if (from == 2) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[2];
        }  else if (from == 3) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[3];
        }  else if (from == 4) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[4];
        }  else if (from == 5) {
            return armory.renderpath.PPM.colorgrading_midtone_uniforms[5];
        } else {
            return 0.0;
        }
    }

}
