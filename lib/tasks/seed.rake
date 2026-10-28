namespace :dss_pnrp do
  desc "Carga datos de prueba (proyecto, usuarios tomadores de decisión y requerimientos) para DSS-PNRP"
  task seed: :environment do
    puts "==> Iniciando carga de datos de prueba para DSS-PNRP..."

    status = IssueStatus.first || IssueStatus.create!(name: "Nueva", is_closed: false)
    priority = IssuePriority.first || IssuePriority.create!(name: "Normal")
    tracker = Tracker.first || Tracker.create!(name: "Requerimiento", default_status_id: status.id)

    role = Role.givable.first || Role.where(builtin: 0).first
    if role.nil?
      role = Role.new(name: "Desarrollador", permissions: [:view_issues, :add_issues, :edit_issues])
      role.builtin = 0
      role.save!
    end

    project = Project.find_or_create_by!(identifier: "pnrp-demo") do |p|
      p.name = "Proyecto Demo DSS-PNRP"
      p.description = "Proyecto de prueba para evaluar priorización y próximo lanzamiento"
      p.is_public = true
    end

    ['prioritization_process', 'next_release_process', 'issue_tracking'].each do |mod|
      project.enabled_modules.find_or_create_by!(name: mod)
    end
    project.trackers << tracker unless project.trackers.include?(tracker)
    project.save!

    puts "-> Proyecto configurado: #{project.name} (#{project.identifier})"

    users_data = [
      { login: "carlos_pm", mail: "carlos@pnrp.test", firstname: "Carlos", lastname: "Gómez (PM)" },
      { login: "laura_po", mail: "laura@pnrp.test", firstname: "Laura", lastname: "Martínez (PO)" },
      { login: "martin_lead", mail: "martin@pnrp.test", firstname: "Martín", lastname: "Sosa (Tech Lead)" }
    ]

    users_data.each do |u_data|
      user = User.find_or_initialize_by(login: u_data[:login])
      user.assign_attributes(
        mail: u_data[:mail],
        firstname: u_data[:firstname],
        lastname: u_data[:lastname],
        status: 1
      )
      user.password = "password123"
      user.password_confirmation = "password123"
      user.save!

      member = Member.find_or_initialize_by(project_id: project.id, user_id: user.id)
      if member.new_record?
        member.roles = [role]
        member.save!
      end
    end

    puts "-> 3 usuarios configurados con rol '#{role.name}'."

    requirements = [
      {
        subject: "REQ-01: Autenticación federada con OAuth2 / Google",
        description: "Permitir a los usuarios registrarse e iniciar sesión utilizando cuentas corporativas de Google Workspace."
      },
      {
        subject: "REQ-02: Exportación de reportes analíticos a PDF y Excel",
        description: "Generación asincrónica de planillas financieras y resúmenes ejecutivos en formatos descargables."
      },
      {
        subject: "REQ-03: Dashboard con métricas y KPIs en tiempo real",
        description: "Panel de control interactivo con gráficos de consumo, latencia y volumen de peticiones procesadas."
      },
      {
        subject: "REQ-04: Notificaciones push para eventos críticos",
        description: "Envío inmediato de alertas al navegador y dispositivos móviles cuando ocurran errores del sistema."
      },
      {
        subject: "REQ-05: Integración con pasarela de pagos Stripe / MP",
        description: "Módulo de checkout para cobro recurrente de suscripciones mensuales y anuales."
      },
      {
        subject: "REQ-06: Módulo de auditoría y trazabilidad de cambios",
        description: "Registro inmutable de accesos administrativos y modificaciones sobre entidades críticas."
      },
      {
        subject: "REQ-07: Pipeline automatizado de CI/CD para staging",
        description: "Configuración de ejecución de tests y despliegue continuo de imágenes Docker."
      }
    ]

    author = User.find_by(admin: true) || User.first

    requirements.each do |req|
      issue = Issue.find_or_initialize_by(project_id: project.id, subject: req[:subject])
      issue.assign_attributes(
        tracker: tracker,
        status: status,
        priority: priority,
        author: author,
        description: req[:description]
      )
      issue.save!
    end

    puts "-> #{requirements.size} requerimientos cargados exitosamente."
    puts "==> Carga finalizada con éxito."
  end
end
