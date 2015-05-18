package sounds
{

	import flash.display.MovieClip;

	import flash.media.SoundChannel;
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.events.Event;


	public class SoundManager extends MovieClip
	{


		private static var currentPlay:String;

		public static var musicVolume:Number;
		public static var sfxVolume:Number;
		private static var queue:LoaderMax;
		private static var sfxs:Array;

		public function SoundManager(Queue:LoaderMax)
		{
			queue = Queue;
			TweenPlugin.activate([VolumePlugin]);
			sfxs = new Array  ;

		}
		public static function setSfxVolume(SfxVolume:Number):void
		{
			sfxVolume = SfxVolume;
			changeSfxVolume();
		}
		public static function setMusicVolume(MusicVolume:Number):void
		{
			musicVolume = MusicVolume;
			if (currentPlay != null)
			{
				var song:MP3Loader = queue.getLoader(currentPlay);
				TweenLite.to(song,.5,{volume:musicVolume});
			}
		}
		public static function changeSfxVolume():void
		{
			//Creating local copy in case sfx_complete occurs while changing volumes
			var copySfx:Array = newTheMap(sfxs);
			var trans:SoundTransform = new SoundTransform(sfxVolume);
			for (var i:int=0; i < copySfx.length; i++)
			{
				if (sfxs.indexOf(copySfx[i]) >= 0)
				{
					copySfx[i].soundTransform = trans;
				}
			}
		}

		public static function sfx(fxName:String):void
		{
			var song:Sound = queue.getContent(fxName);
			var trans:SoundTransform = new SoundTransform(sfxVolume);
			var sound:SoundChannel = song.play(0,0,trans);
			sound.addEventListener(Event.SOUND_COMPLETE, removeSfx);
			sfxs.push(sound);
		}
		private static function removeSfx(e:Event):void
		{
			var sfx:* = e.currentTarget;
			sfxs.splice(sfxs.indexOf(sfx),1);
		}
		public static function bgfx(fxName:String):void
		{
			if (fxName != currentPlay)
			{
				if (currentPlay != null)
				{
					endSong(currentPlay);
				}
				var song:MP3Loader = queue.getLoader(fxName);
				song.volume = musicVolume;
				currentPlay = fxName;
				switch (fxName)
				{
					case "intro" :
						song.gotoSoundTime(1.5);

						TweenLite.from(song,3,{volume:0,ease:Circ.easeIn});
						break;

					case "gameMap" :
						song.gotoSoundTime(5);

						TweenLite.from(song,5,{volume:0});
						break;

					case "battle" :
						song.gotoSoundTime(3);

						TweenLite.from(song,8,{volume:0,ease:Circ.easeIn});
						break;
				}
				song.playSound();
			}

		}
		private static function endSong(st:String):void
		{
			var song:MP3Loader = queue.getLoader(st);
			TweenLite.to(song,4,{volume:0,onComplete:stopSong, onCompleteParams:[song]});
		}
		private static function stopSong(song:MP3Loader):void
		{
			song.pauseSound();
		}
		private static function newTheMap(array:Array):Array
		{
			var newArray:Array = new Array  ;
			for (var i:int = 0; i < array.length; i++)
			{
				var content:* = array[i];
				if (content is Array)
				{
					newArray[i] = newTheMap(content);
				}
				else
				{
					newArray[i] = content;
				}
			}
			return newArray;
		}
	}

}