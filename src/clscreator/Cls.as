﻿package clscreator {
    import clscreator.base.*;

	/**
	 * Class 
	 * @author babyfaction
	 */	
    public class Cls extends BaseCls {

        public static const FINAL:String = "final";
        public static const PUBLIC:String = "public";
        public static const INTERNAL:String = "internal";
        public static const DYNAMIC:String = "dynamic";

        private var Interfaces:Array;
        private var clsName:String;
        private var Propertys:Array;
        private var pack:Pack;
        private var NameSpaces:Array;
        private var type:String;
        private var superClass:SuperCls;
		
		private var comment:Comment;

		/**
		 * @param name class name
		 * @param pack the package
		 * @param itfs interfaces
		 * @param superClass see the class
		 * @param type class type
		 * 
		 */		
        public function Cls(name:String, pack:Pack, itfs:Array=null, superClass:SuperCls=null, type:String="public"){
            Propertys = [];
            NameSpaces = [];
            Interfaces = [];
            super();
            setClsName(name);
            setType(type);
            setPack(pack);
            addInterfaces(itfs);
            setSuperClass(superClass);
            addNameSpaces(null);
        }
		
		public function setComment(c:Comment):void{
			this.comment = c;
		}
        public function getPack():Pack{
            return this.pack;
        }
        public function isContainNameSpace(n:NameSpace):Boolean{
            var nn:NameSpace;
            var name:String = n.getName();
            for each (nn in this.NameSpaces) {
                if (nn.getName() == name){
                    return true;
                };
            };
            return false;
        }
        public function setClsName(name:String):void{
            this.clsName = name;
        }
        public function getMethod(methodName:String):Method{
            var m:Property = getPropertyByName(methodName);
            if (m is Method){
                return m as Method;
            };
            return null;
        }
        public function addInterface(inter:Interfa):void{
            if (!this.Interfaces){
                this.Interfaces = new Array();
            };
            if (!inter){
                return;
            };
            this.Interfaces.push(inter.toString());
            var n:String = inter.getName();
            if (n.indexOf(".") >= 0){
                addNameSpaces(new NameSpace(n));
            };
        }
        public function addNameSpaces(n:NameSpace):void{
            if (!this.NameSpaces){
                this.NameSpaces = new Array();
            };
            if (!n || this.isContainNameSpace(n)){
                return;
            };
            this.NameSpaces.push(n);
        }
        public function addInterfaces(fa:Array):void{
            var inter:Interfa;
            if (!fa){
                return;
            };
            for each (inter in fa) {
                addInterface(inter);
            };
        }
        public function addPropertys(p:Property):void{
            var a:Array;
            var pa:Param;
            if (!this.Propertys){
                this.Propertys = new Array();
            };
            this.Propertys.push(p);
            var t:String = p.getReturnType();
            if (t.indexOf(".") >= 0){
                addNameSpaces(new NameSpace(t));
            };
            if (p is Method){
                a = Method(p).getParams();
                for each (pa in a) {
                    t = pa.getType();
                    if (t.indexOf(".") >= 0){
                        addNameSpaces(new NameSpace(t));
                    };
                };
            };
        }
        public function getClsName():String{
            return this.clsName;
        }
        public function setPack(pack:Pack):void{
            this.pack = pack;
        }
        override public function getIndent():String{
            return "\t";
        }
        public function toString():String{
            var n:NameSpace;
            var p:Property;
            var str:String = "";
            str += this.pack.toString() + "{" + BaseCls.NEW_LINE;
            for each (n in this.NameSpaces) {
                str  += n.toString();
            };
			
			str += BaseCls.NEW_LINE;
			
			if(this.comment) str += this.getIndent() + this.comment.toString() + BaseCls.NEW_LINE;
			
            str += this.getIndent() + this.type + " class " + this.clsName;
            if (this.superClass){
                str  += this.superClass.toString();
            };
            if (this.Interfaces.length > 0){
                str  += Interfa.Mark;
                str  += this.Interfaces.join(",");
            };
            str += BaseCls.NEW_LINE + this.getIndent() + "{" + BaseCls.NEW_LINE;
            for each (p in this.Propertys) {
                str  += p.toString() + BaseCls.NEW_LINE;
            };
            str += this.getIndent() + "}" + BaseCls.NEW_LINE;
            return "/**Powerd by https://github.com/babyfaction see the licenses.md.**/" + BaseCls.NEW_LINE + str + "}";
        }
        public function getPropertyByName(name:String):Property{
            var p:Property;
            for each (p in this.Propertys) {
                if (p.getPropertyName() == name){
                    return p;
                };
            };
            return null;
        }
        public function getVar(varName:String):Var{
            var v:Property = getPropertyByName(varName);
            if (v is Var){
                return v as Var;
            };
            return null;
        }
        public function setType(type:String):void{
            this.type = type;
        }
        public function setSuperClass(sc:SuperCls):void{
            if (!sc){
                return;
            };
            this.superClass = sc;
            var n:String = this.superClass.getName();
            if (n.indexOf(".") >= 0){
                addNameSpaces(new NameSpace(n));
            };
        }

    }
}