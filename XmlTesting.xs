using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace XmlTesing
{
    class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                Console.WriteLine("Elegir acción: ");
                Console.WriteLine("      1. Crear archivo");
                Console.WriteLine("      2. Abrir archivo");
                String q = Console.ReadLine();
                String p = null;
                
                switch (q)
                {
                    case "1":
                        Console.WriteLine(" Ingresar nombre del documento ==> ");
                        p = Console.ReadLine();
                        createDocument(p);
                        break;

                    case "2":
                        Console.WriteLine(" Ingresar nombre del documento ==> ");
                        p = Console.ReadLine();
                        readDocument(p);
                        break;
                    default:
                        return;
                        break;
                }
            }
        }

        private static String cleanLine(String input)
        {
            //Verify that file name, return valid file name...
            String output = null;
            bool q = false;

            for (int i=0; i<input.Length; i++)
            {
                q = char.IsLetterOrDigit(input[i]); 
                if ((q == true)||input[i] == '_')
                {
                    output = output + input[i];
                }
                else
                {
                    output = output + ".xml";
                    return output;
                }
            }
            if (output == null)
            {
                output = "default";
            }
            output = output + ".xml";
            return output;
        }

        public static void createDocument(String input)
        {
            String fileName = cleanLine(input);
    
            Console.WriteLine("Nombre del archivo: {0}", fileName);
            Console.ReadLine();

            XmlTextWriter writer = new XmlTextWriter(fileName, System.Text.Encoding.UTF8);
            writer.WriteStartDocument();
            writer.Formatting = Formatting.Indented;
            writer.Indentation = 2;
            writer.WriteStartElement("PositionList");

            //Llenar con valores base genéricos
            String[] coord1 = { "1", "2", "-1", "0", "3.14", "-3.14" };
            String[] coord2 = { "0", "0", "0", "0", "0", "0" };
            String[] coord3 = { "1", "1", "1", "1", "1", "1" };

            createRobotNode(coord1, "Pick_Pos", writer);
            createRobotNode(coord2, "Wait_Pos", writer); 
            createRobotNode(coord3, "Place_Pos", writer);

            writer.WriteEndElement();
            writer.WriteEndDocument();
            writer.Close();
            Console.WriteLine("Archivo de XML: {0} creado", fileName);
            Console.ReadLine();

            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.Load(fileName);

            Console.Write(doc.InnerXml);
            Console.ReadLine();
        }

        public static void readDocument(String input)
        {
            String fileName = cleanLine(input);
            if (File.Exists(fileName))
            {
                Console.WriteLine("Abriendo archivo: {0}", fileName);
            }
            else
            {
                Console.WriteLine("El archivo no existe...");
                Console.ReadLine();
                Console.WriteLine("Creando archivo...");
                Console.ReadLine();
                createDocument(fileName);
                return;
            }
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            
            doc.Load(fileName);
            String documentString = doc.InnerXml;

            foreach (XmlNode node in doc.DocumentElement.ChildNodes)
            {
                String name = node.InnerText;
                Console.WriteLine(name);
                foreach (XmlNode localNode in node)
                {
                    String loc = localNode.InnerText;
                    Console.WriteLine(loc);

                }
            }

            Console.ReadLine();
        }

        private static void createRobotNode(String[] coord, String type, XmlTextWriter writer)
        {
            String[] nameArray = { "Pos_X", "Pos_Y", "Pos_Z", "Rot_X", "Rot_Y", "Rot_Z" };

            writer.WriteStartElement("Pose");
            writer.WriteAttributeString("Type", type);
            for (int i=0; i<coord.Length; i++)
            {
                writer.WriteElementString(nameArray[i], coord[i]);
            }
            writer.WriteEndElement();
            
        }
    }
}
