package org.web.sdk.net.socket 
{
	import flash.utils.ByteArray;
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.inter.ISocket;
	
	public class RespondEvented extends FtpRead 
	{
		private var socket:ISocket;
		
		public function RespondEvented(socket:ISocket, byte:ByteArray) 
		{
			this.socket = socket;
			super(byte);
		}
		
		public function getSocket():ISocket
		{
			return socket;
		}
		
		//
	}

}