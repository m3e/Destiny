package 
{

	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;

	import sounds.SoundManager;
	import flash.geom.Rectangle;
	import flash.events.Event;

	public class Options extends MovieClip
	{

		private var sharedObject:SharedObject;
		private var musicOnOff:Boolean;
		private var sfxLevel:Number;
		private var musicLevel:Number;

		private var sfxTween:TweenLite;
		private var musicTween:TweenLite;
		private var knobDown:Boolean;
		private var music:Boolean;
		private var sfx:Boolean;

		public function Options()
		{
			MusicBar.soundKnob.addEventListener(MouseEvent.MOUSE_DOWN, mouseSoundKnobDown);
			SfxBar.soundKnob.addEventListener(MouseEvent.MOUSE_DOWN, mouseSoundKnobDown);


			//Get options from save;
			sharedObject = SharedObject.getLocal("Destiny");
			//Set sound and music level
			SfxBar.visible = false;
			MusicBar.visible = false;
			if (sharedObject.data.sfxLevel >= 0)
			{
				sfxLevel = sharedObject.data.sfxLevel;
				if (sfxLevel > 0)
				{
					SoundOn.gotoAndStop(1);
				}
				else
				{
					SoundOn.gotoAndStop(2);
				}
				musicLevel = sharedObject.data.musicLevel;
				if (musicLevel > 0)
				{
					MusicOn.gotoAndStop(1);
				}
				else
				{
					MusicOn.gotoAndStop(2);
				}
			}
			else
			{
				sfxLevel = 1;
				musicLevel = 1
				;
				SoundOn.gotoAndStop(1);
				MusicOn.gotoAndStop(1);
			}
			
			SoundManager.setSfxVolume(sfxLevel);
			if (sfxLevel == 0)
			{
				SfxBar.soundKnob.x = 0;
			}
			else
			{
			SfxBar.soundKnob.x = 53 * sfxLevel;
			}
			SoundManager.setMusicVolume(musicLevel);
			if (musicLevel == 0)
			{
				MusicBar.soundKnob.x = 0;
			}
			else
			{
				MusicBar.soundKnob.x = 53 * musicLevel;
			}
			
			
			
			SoundOn.addEventListener(MouseEvent.CLICK, toggleSound);
			MusicOn.addEventListener(MouseEvent.CLICK, toggleMusic);
			SoundOn.addEventListener(MouseEvent.MOUSE_OVER, sfxBarOn);
			MusicOn.addEventListener(MouseEvent.MOUSE_OVER, musicBarOn);
			SoundOn.addEventListener(MouseEvent.MOUSE_OUT, sfxBarOff);
			MusicOn.addEventListener(MouseEvent.MOUSE_OUT, musicBarOff);
			SfxBar.addEventListener(MouseEvent.MOUSE_OVER, sfxStayUp);
			MusicBar.addEventListener(MouseEvent.MOUSE_OVER, musicStayUp);
			SfxBar.addEventListener(MouseEvent.MOUSE_OUT, sfxGoDown);
			MusicBar.addEventListener(MouseEvent.MOUSE_OUT, musicGoDown);
			MusicBar.addEventListener(MouseEvent.MOUSE_DOWN, barDown);
			SfxBar.addEventListener(MouseEvent.MOUSE_DOWN, barDown);
			sharedObject.data.sfxLevel = sfxLevel;
			sharedObject.data.musicLevel = musicLevel;

			sfxTween = new TweenLite(SfxBar,1,{alpha:0,paused:true,onComplete:makeInvisible,onCompleteParams:[SfxBar]});
			musicTween = new TweenLite(MusicBar,1,{alpha:0,paused:true,onComplete:makeInvisible,onCompleteParams:[MusicBar]});

			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);

			stage.addEventListener(MouseEvent.MOUSE_UP, soundKnobUp);
		}
		private function mouseChangeVolume(e:Event):void
		{
			changeVolume(e.currentTarget)
		}
		private function changeVolume(soundObj:Object):void
		{
			var volNum:Number = soundObj.x / 53;
			switch (soundObj.parent)
			{
				case MusicBar :
					SoundManager.setMusicVolume(volNum);
					musicLevel = volNum;
					sharedObject.data.musicLevel = musicLevel;
					if (musicLevel == 0)
					{
						MusicOn.gotoAndStop(2)
					}
					else
					{
						MusicOn.gotoAndStop(1)
					}
					break;

				case SfxBar :
					SoundManager.setSfxVolume(volNum);
					sfxLevel = volNum;
					sharedObject.data.sfxLevel = sfxLevel;
					if (sfxLevel == 0)
					{
						SoundOn.gotoAndStop(2)
					}
					else
					{
						SoundOn.gotoAndStop(1)
					}
					break;
			}
			sharedObject.flush();
		}
		private function barDown(e:MouseEvent):void
		{
			e.currentTarget.soundKnob.x = e.currentTarget.mouseX
			changeVolume(e.currentTarget.soundKnob);
			soundKnobDown(e.currentTarget.soundKnob)
		}
		private function soundKnobDown(sndKnob:Object):void
		{
			sndKnob.startDrag(true,new Rectangle(0,-4,53,0));
			sndKnob.addEventListener(Event.ENTER_FRAME, mouseChangeVolume);
			knobDown = true;
			switch (sndKnob.parent)
			{
				case MusicBar :
					music = true;
					sfx = false;
					break;

				case SfxBar :
					sfx = true;
					music = false;
					break;
			}
		}
		private function mouseSoundKnobDown(e:MouseEvent):void
		{
			soundKnobDown(e.currentTarget);
		}
		private function soundKnobUp(e:MouseEvent):void
		{
			if (knobDown == true)
			{
				if (music == true)
				{
					MusicBar.soundKnob.removeEventListener(Event.ENTER_FRAME, changeVolume);
					musicTween.play()
				}
				else if (sfx == true)
				{
					SfxBar.soundKnob.removeEventListener(Event.ENTER_FRAME, changeVolume);
					sfxTween.play()
				}
				knobDown = false;
				stopDrag();
				sfx = false;
				music = false;
			}
		}
		private function sfxStayUp(e:MouseEvent):void
		{
			sfxTween.restart();
			sfxTween.pause();
			SfxBar.alpha = 1;
		}
		private function musicStayUp(e:MouseEvent):void
		{
			musicTween.restart();
			musicTween.pause();
			MusicBar.alpha = 1;
		}
		private function musicGoDown(e:MouseEvent):void
		{
			if (knobDown == false)
			{
				musicTween.restart();
			}
		}
		private function sfxGoDown(e:MouseEvent):void
		{
			if (knobDown == false)
			{
				sfxTween.restart();
			}
		}
		private function sfxBarOn(e:MouseEvent):void
		{
			sfxTween.restart();
			sfxTween.pause();
			SfxBar.alpha = 1;
			SfxBar.visible = true;
		}
		private function musicBarOn(e:MouseEvent):void
		{
			musicTween.restart();
			musicTween.pause();
			MusicBar.alpha = 1;
			MusicBar.visible = true;
		}
		private function sfxBarOff(e:MouseEvent):void
		{
			if (knobDown == false)
			{
				sfxTween.play();
			}
		}
		private function musicBarOff(e:MouseEvent):void
		{
			if (knobDown == false)
			{
				musicTween.play();
			}
		}
		private function makeInvisible(thisTarget:Object):void
		{
			thisTarget.visible = false;
		}
		private function toggleSound(e:MouseEvent):void
		{
			if (sfxLevel > 0)
			{
				sfxLevel = 0;
				SfxBar.soundKnob.x = 0;
				SoundOn.gotoAndStop(2);
			}
			else
			{
				sfxLevel = .6;
				SfxBar.soundKnob.x = 53 * sfxLevel;
				SoundOn.gotoAndStop(1);
			}
			SoundManager.setSfxVolume(sfxLevel);
			sharedObject.data.sfxLevel = sfxLevel;
			sharedObject.flush();
		}
		private function toggleMusic(e:MouseEvent):void
		{
			if (musicLevel > 0)
			{
				musicLevel = 0;
				MusicBar.soundKnob.x = 0;
				MusicOn.gotoAndStop(2);
			}
			else
			{
				musicLevel = .6;
				MusicBar.soundKnob.x = 53 * musicLevel
				MusicOn.gotoAndStop(1);
			}
			SoundManager.setMusicVolume(musicLevel);
			sharedObject.data.musicLevel = musicLevel;
			sharedObject.flush();
		}

	}

}