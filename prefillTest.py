import sys
import argparse
import fcntl
import termios

class App:

	def __init__(self):
		pass

	def get_args(self):
		parser = argparse.ArgumentParser()
		parser.add_argument('cmd', nargs='+', help='arguments to combine into a single string')
		args = parser.parse_args()

		combined_args = ' '.join(args.cmd)

		return combined_args

	def run(self):
		args = self.get_args()
		self.prefil_shell_cmd(args)

	def prefil_shell_cmd(self, cmd):
		"""cmd needs to be in the form of a string"""
		stdin = 0
		# save TTY attribute for stdin
		oldattr = termios.tcgetattr(stdin)
		# create new attributes to fake input
		newattr = termios.tcgetattr(stdin)
		# disable echo in stdin -> only inject cmd in stdin queue (with TIOCSTI)
		newattr[3] &= ~termios.ECHO
		# enable non canonical mode -> ignore special editing characters
		newattr[3] &= ~termios.ICANON
		# use the new attributes
		termios.tcsetattr(stdin, termios.TCSANOW, newattr)
		# write the selected command in stdin queue
		for c in cmd:
			fcntl.ioctl(stdin, termios.TIOCSTI, c)
		# restore TTY attribute for stdin
		termios.tcsetattr(stdin, termios.TCSADRAIN, oldattr)


def main():
	try:
		App().run()
	except KeyboardInterrupt:
		exit(0)


if __name__ == "__main__":
	main()
