package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;	
	import sounds.SoundManager;
	
	
	public class Preloader extends MovieClip {
		
		private var mainGame:Main;
		private var options:Options;
		private var soundManager:SoundManager;
		private var queue:LoaderMax;
		private var preloaderBar:PreloaderBar
			
		public function Preloader() {
			queue = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete: completeHandler});
			preloaderBar = new PreloaderBar();
			addChild(preloaderBar)
			preloaderBar.x = 156;
			preloaderBar.y = 200;
			//Preload sounds
			
			/*queue.append(new MP3Loader("sounds/sfx/buttonclick.mp3", {name:"clickbutton", volume:1, autoPlay:false, estimatedBytes: 2000}));
			
			queue.append(new MP3Loader("sounds/TelLMeYouWill.mp3", {name:"intro", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			queue.append(new MP3Loader("sounds/mhifwstts.mp3", {name:"gameMap", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			queue.append(new MP3Loader("sounds/littlefox.mp3", {name:"battle", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			
			queue.append(new MP3Loader("sounds/sfx/shieldBlock.mp3", {name:"shieldblock", volume:1, autoPlay:false, estimatedBytes: 2000}));
			queue.append(new MP3Loader("sounds/sfx/swordStrike.mp3", {name:"swordhit", volume:1, autoPlay:false, estimatedBytes: 2000}));
			*/
			
			//Queue via dropbox
			
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/fkdlcr3e9ge5krb/buttonclick.mp3", {name:"clickbutton", volume:1, autoPlay:false, estimatedBytes: 2000}));
			
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/p9u7wlun7xi40g8/TMYW.mp3", {name:"intro", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/xflhebtvqfhuuym/mhifwstts.mp3", {name:"gameMap", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/m7z991p6vrp7brg/LFox.mp3", {name:"battle", repeat:-1, volume:1, autoPlay:false, estimatedBytes: 9500}));
			
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/oyfhcudrxqvpil4/shblock.mp3", {name:"shieldblock", volume:1, autoPlay:false, estimatedBytes: 2000}));
			queue.append(new MP3Loader("https://dl.dropboxusercontent.com/s/wykubut91hcocgq/swhit.mp3", {name:"swordhit", volume:1, autoPlay:false, estimatedBytes: 2000}));
			

			queue.load();
			
			//init()
		}
		private function init():void
		{
			soundManager = new SoundManager(queue);
			mainGame = new Main();
			options = new Options();
			addChild(mainGame);
			addChild(options);
		}
		private function progressHandler(e:LoaderEvent):void
		{
			var percentLoad:String = (e.target.progress * 100).toFixed(0)
			
			preloaderBar.ProgressText.text =  percentLoad
			
			preloaderBar.Progress.scaleX = e.target.progress
		}
		private function completeHandler(e:LoaderEvent):void
		{
			init();
			doExit();
		}
		private function doExit():void
		{
			
			soundManager = null;
			queue = null;
			removeChild(preloaderBar);
			preloaderBar = null;
		}
	}
	
}
