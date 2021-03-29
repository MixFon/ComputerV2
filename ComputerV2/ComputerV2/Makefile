# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: widraugr <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/29 13:07:44 by widraugr          #+#    #+#              #
#    Updated: 2021/03/29 19:40:56 by mixfon           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = computer

FILE_SWIFT = Computer.swift\
			 Checker.swift\
			 Enums.swift\
			 Extension.swift\
			 Function.swift\
			 Imaginary.swift\
			 Matrix.swift\
			 Rational.swift\
			 TypeProtocol.swift\
			 Variable.swift\
			 main.swift\
			 Polinom/Equation.swift\
			 Polinom/Monom.swift\
			 Polinom/Polinom.swift

all : $(NAME)

$(NAME): $(FILE_SWIFT)
	swiftc $(FILE_SWIFT) -o computer

clean:
	/bin/rm -f $(NAME)
	
re: clean all 
