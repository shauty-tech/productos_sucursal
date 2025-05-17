# Archivo: .idx/dev.nix
{ pkgs, lib, ... }: # Asegúrate de incluir 'lib' aquí
{
  # Canal de nixpkgs (puedes usar el del ejemplo que te funciona)
  channel = "stable-23.11"; # O "unstable", según prefieras o si el otro proyecto usa uno específico

  # Define todos los paquetes (herramientas, entornos de lenguaje) que necesitas en tu entorno de IDX
  packages = [
    # Puedes añadir paquetes del sistema operativo o herramientas aquí si tu aplicación los necesita
    # Por ejemplo (como en tu ejemplo que funciona): pkgs.nodejs_20; pkgs.python3;
    # PERO, para que use requirements.txt, necesitamos esta forma específica de definir Python:

    # --- Configuración para el Entorno Python con requirements.txt ---
    # Usamos python311 y le decimos que construya un entorno CON los paquetes de requirements.txt
    # Esta es la forma de Nix para manejar dependencias de Python desde un archivo
    pkgs.python311.withPackages(ps: ps.buildEnv {
      # Esta línea crucial le dice a Nix que instale los paquetes listados en el archivo requirements.txt
      # La ruta es relativa a la ubicación del archivo dev.nix (que está en .idx/)
      requirements = ../requirements.txt;

      # Si tienes paquetes adicionales que no están en requirements.txt pero necesitas, puedes añadirlos aquí directamente:
      # extraLibs = with ps; [
      #   nombre-de-paquete-extra-python
      #   otro-paquete
      # ];
    })
    # --- Fin Configuración Python con requirements.txt ---

    # --- Otros paquetes (como Node.js si lo necesitas para Angular) ---
    # Si necesitas Node.js para la parte de Angular, añádelo a esta *misma lista de packages*:
    # pkgs.nodejs_20 # Añade Node.js versión 20 (o la que necesites)
    # --- Fin Otros paquetes ---

    # Añade otros paquetes de Nixpkgs aquí si son necesarios para tu desarrollo
    # pkgs.alguna-otra-herramienta
  ];

  # Otras configuraciones de nivel superior que sí permite Project IDX (como viste en tu ejemplo)
  env = {}; # Variables de entorno
  idx = { # Opciones específicas de Project IDX
    extensions = [
      # "publisher.id" de extensiones de open-vsx.org
    ];
    previews = { enable = true; previews = {}; }; # Configuración de vistas previas
    workspace = { onCreate = {}; onStart = {}; }; # Hooks del ciclo de vida
  };

  # Puedes comentar o eliminar las secciones env, idx, previews, workspace si no las necesitas por ahora,
  # pero la estructura principal { pkgs, lib, ... }: { channel = ...; packages = [...]; ... } debe mantenerse.
}