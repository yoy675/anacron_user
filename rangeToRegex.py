#!/usr/bin/env python3.12
#
#  rangeToRegex.py
#
#  Copyright 2025 David Robinson <darobins@g.jct.ac.il>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#


import sys,regex

def asteriskRange(time,mod=1):
	if mod==0:
		rang=rangeToRegex("[0-59]",mod)
	elif mod==1:
		rang=rangeToRegex("[0-23]",mod)
	elif mod==2:
		rang=rangeToRegex("[1-31]",mod)
	elif mod==3:
		rang=rangeToRegex("[1-12]",mod)
	elif mod==4:
		rang=rangeToRegex("[0-6]",mod)
	return rang


def rangeToRegex(string,mod=1):
	regex_strings=[]
	for ranges in string.split(","):
		if ranges.count("-")==0:
			regex_strings.append(regx)
			continue
		rang=ranges.strip("[]").split("-")
		if len(rang[0])==len(rang[1])==1:
			if mod==1:
				regex_strings.append(f"{rang[0]}-{rang[1]}")
			else:
				for i in range(int(rang[0]),int(rang[1])+1):
					if not i%mod: regex_strings.append(i)
		elif len(rang[0])==1:
			if mod==1:
				regex_strings.append(f"{rang[0]}-9")
				regex_strings.extend([str(i) for i in range(10,int(rang[1])+1,mod)])
			else:
				for i in range(int(rang[0]),10):
					if not i%mod: regex_strings.append(i)
				for i in range(10,int(rang[1])+1,mod):
					if not i%mod: regex_strings.append(i)
		else:
			regex_strings.extend([str(i) for i in range(int(rang[0]),int(rang[1])+1,mod)])
	return f"[{'|'.join(regex_strings)}]"

def lin(line,time):
	n=["",""]
	part=[]
	if line.count("@"):
		n=line.split(maxsplit=1)
		if n[0]=="@reboot":
			print(f'{n[1]}')
		elif "@annually"==n[0]=="@yearly":
			line="0 0 1 1 *"+n[1]
		elif n[0]=="@monthly":
			line="0 0 1 * *"+n[1]
		elif n[0]=="@weekly":
			line="0 0 * * 0"+n[1]
		elif "@midnight"==n[0]=="@daily":
			line="0 0 * * *"+n[1]
		elif n[0]=="@hourly":
			line="0 * * * *"+n[1]
	for a in line.split(maxsplit=5)[:5]:
		mod=1
		if a.count("/")==1:
			a,mod=a.split("/")
		if a.count("-")>0:
			part.append(rangeToRegex(a,mod))
		elif a=="*":
			part.append(f".*") if mod==1 else asteriskRange(len(part),mod)
		elif a.count(",")!=0:
			part.append(a.replace(",","|"))
		elif 3<=len(part)<=4 and a.isalpha():
			if len(part)==3:
				match a.lower():
					case "jan":
						part.append(1)
					case "feb":
						part.append(2)
					case "may":
						part.append(3)
					case "apr":
						part.append(4)
					case "mar":
						part.append(5)
					case "jun":
						part.append(6)
					case "jul":
						part.append(7)
					case "aug":
						part.append(8)
					case "sep":
						part.append(9)
					case "oct":
						part.append(10)
					case "nov":
						part.append(11)
					case "dec":
						part.append(12)
			elif len(part)==4:
				match a.lower():
					case "sun":
						part.append(1)
					case "mon":
						part.append(2)
					case "tue":
						part.append(3)
					case "wed":
						part.append(4)
					case "thu":
						part.append(5)
					case "fri":
						part.append(6)
					case "sat":
						part.append(7)
		else:
			part.append(a)
	n[0]=" ".join(part)
	n[1]=line.split(maxsplit=5)[5]
	if regex.match(n[0],time): print(f'{n[1]}')

def main(args):
	for line in regex.split("\n",args[0]):
		lin(line,args[1])
	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))