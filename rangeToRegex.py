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


import sys

def asteriskRange(time,mod=1):
	if time==0:
		rang=rangeToRegex("[0-59]",mod)
	elif time==1:
		rang=rangeToRegex("[0-23]",mod)
	elif time==2:
		rang=rangeToRegex("[1-31]",mod)
	elif time==3:
		rang=rangeToRegex("[1-12]",mod)
	elif time==4:
		rang=rangeToRegex("[0-6]",mod)
	return rang


def rangeToRegex(string,mod=1):
	regex_strings,ran=[],[]
	for ranges in string.split(","):
		if ranges.count("-")==0:
			regex_strings.append(ranges)
			ran.append(ranges)
			continue
		rang=[int(a) for a in ranges.strip("[]").split("-")]
		ran.extend([i for i in range(rang[0],rang[1]+1)])
	return ran

def lin(line,time):
	n=["",""]
	part,rang=[], []
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
			a=a.split("/")[0]
			mod=int(a.split("/")[1])
		if a.count("-")>0:
			part.append(rangeToRegex(a,mod))
		elif a=="*":
			part.append(asteriskRange(len(part),mod))
		elif a.count(",")!=0:
			part.append(a.split(','))
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
			if len(part)==4:
				part.append(int(a)%7)
			else:
				part.append(int(a))
		if type(part[-1])==int:
			rang.append(int(part[-1]))
			continue
		rang.append([int(i) for i in part[-1] if not int(i)%mod])
	n[0]=" ".join(f"{part}")
	n[1]=line.split(maxsplit=5)[5]
	if len([i for i in range(5) if (type(rang[i])==int and int(time[i])==rang[i]) or (type(rang[i])==list and int(time[i]) in rang[i])])==5:
		print(n[1])

def main(args):
	for line in args[0].split("\n"):
		if not line or len(args)<2 or not args[1]: return 0
		lin(line,args[1].split())
	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))