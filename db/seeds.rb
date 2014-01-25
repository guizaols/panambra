usuario = Usuario.new(nome: 'Administrador',
											login: 'administrador',
											email: 'admin@devconnit.com',
											tipo: Usuario::ADMINISTRADOR_GERAL_DO_SISTEMA,
											password: 'qwe123@',
											password_confirmation: 'qwe123@',
											situacao: Usuario::ATIVO)
usuario.save(validate: false)
